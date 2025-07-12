module instr_reg(
    input clk,        // Clock signal
    input rst,        // Active low reset signal
    input [1:0] fetch, // Control signal for instruction source
    input [7:0] data,  // 8-bit data input
    output [2:0] ins,  // High 3 bits of the instruction (opcode)
    output [4:0] ad1,  // Low 5 bits of the instruction (register address)
    output [7:0] ad2   // Full 8-bit data from the second source
);

reg [7:0] ins_p1; // First 8-bit register
reg [7:0] ins_p2; // Second 8-bit register

always @(posedge clk) begin
    if (~rst) begin
        // Reset condition: Initialize both registers to zero
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data; // Fetch instruction into ins_p1
            2'b10: ins_p2 <= data; // Fetch instruction into ins_p2
            default: ; // Retain previous values
        endcase
    end
end

// Derive output signals from the stored instructions
assign ins = ins_p1[7:5]; // High 3 bits of the instruction (opcode)
assign ad1 = ins_p1[4:0]; // Low 5 bits of the instruction (register address)
assign ad2 = ins_p2;      // Full 8-bit data from the second source

endmodule