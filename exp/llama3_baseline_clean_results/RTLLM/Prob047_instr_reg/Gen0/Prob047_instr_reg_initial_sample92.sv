module instr_reg(
    input clk,            // Clock signal for synchronization
    input rst,            // Active low reset signal to initialize the register
    input [1:0] fetch,    // Control signal indicating the source of the instruction
    input [7:0] data,     // 8-bit data input representing the instruction to be fetched
    output [2:0] ins,     // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,     // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2      // The full 8-bit data from the second source
);

reg [7:0] ins_p1;         // First 8-bit register to store instructions
reg [7:0] ins_p2;         // Second 8-bit register to store instructions

// Initialize registers on reset
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        ins_p1 <= 8'd0;  // Initialize ins_p1 to zero on reset
        ins_p2 <= 8'd0;  // Initialize ins_p2 to zero on reset
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data;  // Fetch instruction from data into ins_p1
            2'b10: ins_p2 <= data;  // Fetch instruction from data into ins_p2
            default: begin         // Retain previous values if fetch is not 2'b01 or 2'b10
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

// Derive output signals from stored instructions
assign ins = ins_p1[7:5];  // High 3 bits of the instruction from ins_p1
assign ad1 = ins_p1[4:0];  // Low 5 bits of the instruction from ins_p1
assign ad2 = ins_p2;      // Full 8-bit data from ins_p2

endmodule