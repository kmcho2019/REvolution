module instr_reg(
    input clk,            // Clock signal
    input rst_n,          // Active low reset signal
    input [1:0] fetch,    // Control signal for instruction source
    input [7:0] data,     // 8-bit data input
    output [2:0] ins,     // High 3 bits of the instruction (opcode)
    output [4:0] ad1,     // Low 5 bits of the instruction (register address)
    output [7:0] ad2      // Full 8-bit data from the second source
);

reg [7:0] ins_p1;         // First 8-bit register
reg [7:0] ins_p2;         // Second 8-bit register

// Sequential logic to update the registers based on fetch and reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin     // Reset condition
        ins_p1 <= 8'b0;
        ins_p2 <= 8'b0;
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data;  // Update ins_p1 if fetch is 2'b01
            2'b10: ins_p2 <= data;  // Update ins_p2 if fetch is 2'b10
            default: begin         // Retain previous values for other fetch conditions
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

// Continuous assignments for output logic
assign ins = ins_p1[7:5];  // Derive ins from high 3 bits of ins_p1
assign ad1 = ins_p1[4:0];  // Derive ad1 from low 5 bits of ins_p1
assign ad2 = ins_p2;      // Derive ad2 from ins_p2

endmodule