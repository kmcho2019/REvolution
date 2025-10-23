module instr_reg(
    input clk,      // Clock signal
    input rst,      // Active low reset signal
    input [1:0] fetch, // Control signal for instruction source
    input [7:0] data,  // 8-bit data input representing the instruction

    output [2:0] ins,  // High 3 bits of the instruction (opcode)
    output [4:0] ad1,  // Low 5 bits of the instruction (register address)
    output [7:0] ad2   // Full 8-bit data from the second source
);

reg [7:0] ins_p1;  // First 8-bit register
reg [7:0] ins_p2;  // Second 8-bit register

// Reset logic
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        ins_p1 <= 8'd0;  // Initialize ins_p1 to zero on reset
        ins_p2 <= 8'd0;  // Initialize ins_p2 to zero on reset
    end else begin
        // Fetch logic
        case (fetch)
            2'b01: ins_p1 <= data;  // Update ins_p1 with data when fetch is 2'b01
            2'b10: ins_p2 <= data;  // Update ins_p2 with data when fetch is 2'b10
            default: begin  // Retain previous values when fetch is neither 2'b01 nor 2'b10
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

// Derive outputs from stored instructions
assign ins = ins_p1[7:5];  // ins is the high 3 bits of ins_p1
assign ad1 = ins_p1[4:0];  // ad1 is the low 5 bits of ins_p1
assign ad2 = ins_p2;       // ad2 is the full 8-bit ins_p2

endmodule