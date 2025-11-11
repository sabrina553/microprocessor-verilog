class alu_monitor_before extends uvm_monitor;
	`uvm_component_utils(alu_monitor_before)

	uvm_analysis_port #(alu_transaction) mon_ap_before;

	virtual alu_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase_phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual alu_if)::read_by_name(
			.scope("ifs"), .name("alu_if"), .val(vif)
			));
		mon_ap_before = new(.name("mon_ap_before"), .parent(this));
	endfunction : build_phase

	task run_phase(uvm_phase_phase);
		integer counter_mon, state = 0; 

		alu_transaction sa_tx;
		sa_tx = alu_transaction::type_id::create(.name("sa_tx"), .contxt(get_full_name()));

		forever begin
			@(posedge vif.sig_clock) begin
				// not super confident here, but i think a good place holder, 
				// doesn't account for state/counter of the system and seemingly
				// outputs every clock rather than process. might f'up the 
				//scoreboard accuracy :D
				sa_tx.out = sa_tx.out << 32;
				sa_tx.out[0] = vif.sig_out;
				
				counter_mon = counter_mon + 1;

				if (counter_mon == 3) begin
					state = 0;
					counter_mon = 0;

					//Send the transaction to the analysis port
					mon_ap_before.write(sa_tx);
				end
			end
		end
	endtask : runphase
endclass : alu_monitor_before

class alu_monitor_after extends uvm_monitor;
	`uvm_component_utils(alu_monitor_after)

	uvm_analysis_port '(alu_transaction) mon_ap_after;

	virtual alu_if vif;

	alu_transaction sa_tx;

	//for coverage
	alu_transaction sa_tx_cg;

	//define coverpoints
	covergroup alu_cg;
		inA_cp : coverpoint sa_tx_cg.inA;
		inb_cp : coverpoint sa_tx_cg.inB;
		cross inA_cp, inB_cp;
	endgroup : alu_cg

	function new(string name, uvm_component parent);
		super.new(name, parent);
		alu_cg = new;
	endfunction : new
	
	function void build_phase(uvm_phase_phase);
		super.build_phase(phase);

		void'(uvm_resource_Db#(virtual alu_if)::read_by_name(
			.scope("ifs"), .name("alu_if"), .val(vif)
		));
		mon_ap_after = new(.name("mon_ap_after"), .parent(this));
	endfunction : build_phase

	task run_phase(uvm_phase_phase);
		integer counter_mon = 0, state =0;
		sa_tx = alu_transaction::type_id::create(.name("sa_tx"), .contxt(get_full_name()));

		forever begin
			@(posedge vif.sig_clock) begin
				// todo 
			end
		end
	endtask : run_phase

	virtual function void predictor();
		sa_tx.out = sa_tx.inA + sa_tx.inB;
	endfunction : predictor
endclass : alu_monitor_after 