module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [7:0] ins_reg;  // Dual-port register for storing instructions

// Fetch signal decoder
wire write_enable_p1 = (fetch == 2'b01)? 1'b1 : 1'b0;
wire write_enable_p2 = (fetch == 2'b10)? 1'b1 : 1'b0;

// Simplified clocking and reset logic
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        ins_reg <= 8'd0;
    end else if (write_enable_p1) begin
        ins_reg <= data;
    end else if (write_enable_p2) begin
        ins_reg <= data;
    end
end

// Minimal combinational logic for output assignments
assign ins = ins_reg[7:5];  // High 3 bits of the instruction
assign ad1 = ins_reg[4:0];  // Low 5 bits of the instruction
assign ad2 = ins_reg;       // Full 8-bit data

endmodule