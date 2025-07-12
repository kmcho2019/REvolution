module instr_reg(
    input clk,          // Clock signal
    input rst_n,        // Active low reset signal
    input [1:0] fetch,  // Control signal for instruction source
    input [7:0] data,   // 8-bit data input
    output [2:0] ins,   // High 3 bits of the instruction (opcode)
    output [4:0] ad1,   // Low 5 bits of the instruction (register address)
    output [7:0] ad2    // Full 8-bit data from the second source
);

reg [7:0] ins_p1;  // First 8-bit register
reg [7:0] ins_p2;  // Second 8-bit register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset both registers to zero
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
        case (fetch)
            2'b01: begin
                // Fetch instruction into ins_p1 from data input
                ins_p1 <= data;
                // ins_p2 retains its previous value
            end
            2'b10: begin
                // Fetch instruction into ins_p2 from data input
                ins_p2 <= data;
                // ins_p1 retains its previous value
            end
            default: begin
                // Both registers retain their previous values
            end
        endcase
    end
end

assign ins = ins_p1[7:5];  // High 3 bits of ins_p1
assign ad1 = ins_p1[4:0];  // Low 5 bits of ins_p1
assign ad2 = ins_p2;       // Full 8-bit value of ins_p2

endmodule