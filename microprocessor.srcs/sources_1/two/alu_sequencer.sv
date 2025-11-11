class alu_transaction extends uvm_sequence_item;
  rand bit [31:0] inA;
  rand bit [31:0] inB;
  // rand bit [5:0] opcode; ??????  
  bit [31:0] out;

  function new(string name = "");
    super.new(name);
  endfunction : new

  `uvm_object_utils_begin(alu_transaction)
    `uvm_field_int(inA, UVM_ALL_ON)
    `uvm_field_int(inB, UVM_ALL_ON)
    `uvm_field_int(out, UVM_ALL_ON)
  `uvm_object_utils_end
endclass : alu_transaction

class alu_sequence extends uvm_sequence #(alu_transaction);
  `uvm_object_utils(alu_sequence)

  function new(string name = "");
    super.new(name);
  endfunction : new

  task body();
    alu_transaction sa_tx;
    repeat (15) begin
      sa_tx = alu_transaction::type_id::create(.name("sa_tx"), .contxt(get_full_name()));
    
      start_item(sa_tx);
      assert (sa_tx.randomize());
      //`uvm_info("sa_sequence", sa_tx.sprint(), UVM_LOW);
      finish_item(sa_tx);
    end
  endtask : body
endclass : alu_sequence

typedef uvm_sequencer#(alu_transaction) alu_sequencer;