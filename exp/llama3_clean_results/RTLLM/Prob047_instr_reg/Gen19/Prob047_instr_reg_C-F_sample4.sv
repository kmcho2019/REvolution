module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [7:0] ins_p1;  // 8-bit register for first instruction
reg [7:0] ins_p2;  // 8-bit register for second instruction

// Efficient reset logic using assign
assign ins_p1 = (~rst)? 8'd0 : (fetch == 2'b01)? data : ins_p1;
assign ins_p2 = (~rst)? 8'd0 : (fetch == 2'b10)? data : ins_p2;

// Minimal combinational logic for output assignments
assign ins = ins_p1[7:5];  // High 3 bits of the first instruction
assign ad1 = ins_p1[4:0];  // Low 5 bits of the first instruction
assign ad2 = ins_p2;       // Full 8-bit data from the second instruction

endmodule