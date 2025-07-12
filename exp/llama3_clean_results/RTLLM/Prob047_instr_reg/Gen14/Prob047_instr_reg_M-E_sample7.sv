module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [7:0] ins_reg;  // Single 8-bit register to store instructions

// Reset logic using assign
assign ins_reg = (~rst)? 8'd0 : ins_reg;

// Clock-based update logic for ins_reg
always @(posedge clk) begin
    if (~rst) begin
        ins_reg <= 8'd0;
    end else if (fetch == 2'b01) begin
        ins_reg <= data;
    end else if (fetch == 2'b10) begin
        ins_reg <= data;
    end
end

// Output logic using latch
reg [2:0] ins_latch;  // Latch for ins output
reg [4:0] ad1_latch;  // Latch for ad1 output
reg [7:0] ad2_latch;  // Latch for ad2 output

always @(posedge clk) begin
    ins_latch <= ins_reg[7:5];
    ad1_latch <= ins_reg[4:0];
    ad2_latch <= ins_reg;
end

assign ins = ins_latch;  // Assign ins output from latch
assign ad1 = ad1_latch;  // Assign ad1 output from latch
assign ad2 = ad2_latch;  // Assign ad2 output from latch

endmodule