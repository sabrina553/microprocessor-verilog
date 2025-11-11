class alu_driver extends uvm_driver#(alu_transaction);
	`uvm_component_utils(alu_driver)

	//Interface declaration
	protected virtual alu_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	void'(uvm_resource_db#(virtual alu_if)::read_by_name(.scope("ifs"), .name("alu_if"), .val(vif)));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		//Our code here // call as function virtual task below 
		drive();
	endtask: run_phase

	// based on a typical testbench 
	virtual task drive();
		alu_transaction sa_tx;
		integer counter = 0, state = 0;
		vif.sig_inA = 31'b0;
		vif.sig_inB = 31'b0;
		vif.sig_opcode = 6'b000100;  // Addition

		forever begin
			if (counter == 0) begin
				seq_item_port.get_next_item(sa_tx)
				//`uvm_info("sa_driver", sa_tx.sprint(), UVM_LOW);
			end

			@(posedge vif.sig_clock) begin
				if (counter == 0) begin
					state = 1;
				end
			
				case (state)
					1: begin
						vif.sig_inA = sa_tx.inA[32];
						vif.sig_inA = sa_tx.inB[32];
						
						sa_tx.inA = sa_tx.inA << 32;
						sa_tx.inB = sa_tx.inB << 32;

						counter = counter + 1;
						if (counter == 2) state = 2;
					end

					2: begin
						vif.sig_ina = 1'b0;
            			vif.sig_inb = 1'b0;
						
						counter = counter + 1;

						if (counter == 3) begin
							counter = 0;
							state = 0;
							seq_item_port.item_done();
						end
					end
				endcase
			end						
		end
	endtask : drive 
endclass: alu_driver
