module instr_reg(
    input clk,            // Clock signal for synchronization
    input rst,            // Active low reset signal
    input [1:0] fetch,   // Control signal indicating the source of the instruction
    input [7:0] data,    // 8-bit data input representing the instruction
    output [2:0] ins,    // High 3 bits of the instruction
    output [4:0] ad1,    // Low 5 bits of the instruction
    output [7:0] ad2     // Full 8-bit data from the second source
);

reg [7:0] ins_p1; // First 8-bit register to store instructions
reg [7:0] ins_p2; // Second 8-bit register to store instructions

always @(posedge clk or negedge rst) begin
    if (~rst) begin // Reset condition
        ins_p1 <= 8'd0; // Initialize ins_p1 to zero
        ins_p2 <= 8'd0; // Initialize ins_p2 to zero
    end else begin
        case (fetch) // Based on the fetch signal
            2'b01: ins_p1 <= data; // Fetch instruction into ins_p1
            2'b10: ins_p2 <= data; // Fetch instruction into ins_p2
            default: begin // Retain previous values if neither condition is met
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

assign ins = ins_p1[7:5]; // High 3 bits of ins_p1 as ins output
assign ad1 = ins_p1[4:0]; // Low 5 bits of ins_p1 as ad1 output
assign ad2 = ins_p2; // Full 8 bits of ins_p2 as ad2 output

endmodule