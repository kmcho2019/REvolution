module instr_reg(
    input clk,    // Clock signal
    input rst,    // Active low reset signal
    input [1:0] fetch,  // Control signal to select instruction source
    input [7:0] data,   // 8-bit data input representing the instruction
    output [2:0] ins,   // High 3 bits of the instruction (opcode)
    output [4:0] ad1,   // Low 5 bits of the instruction (register address)
    output [7:0] ad2    // Full 8-bit data from the second source
);

reg [7:0] ins_p1;  // First 8-bit register to store instruction
reg [7:0] ins_p2;  // Second 8-bit register to store instruction

always @(posedge clk or negedge rst) begin
    if (~rst) begin  // If reset is low, initialize both registers to zero
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data;  // If fetch is 2'b01, fetch instruction into ins_p1
            2'b10: ins_p2 <= data;  // If fetch is 2'b10, fetch instruction into ins_p2
            default: begin  // If neither condition is met, retain previous values
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

assign ins = ins_p1[7:5];  // Derive ins output from high 3 bits of ins_p1
assign ad1 = ins_p1[4:0];  // Derive ad1 output from low 5 bits of ins_p1
assign ad2 = ins_p2;       // Derive ad2 output from ins_p2

endmodule