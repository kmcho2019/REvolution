module instr_reg(
    input clk, // Clock signal for synchronization
    input rst_n, // Active low reset signal to initialize the register
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data, // 8-bit data input representing the instruction to be fetched
    output [2:0] ins, // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1, // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2 // The full 8-bit data from the second source
);

reg [7:0] ins_p1; // First 8-bit register to store instructions
reg [7:0] ins_p2; // Second 8-bit register to store instructions

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset condition
        ins_p1 <= 8'd0; // Initialize ins_p1 to zero
        ins_p2 <= 8'd0; // Initialize ins_p2 to zero
    end else begin
        case (fetch) // Check the value of the fetch signal
            2'b01: begin // If fetch is 2'b01, update ins_p1
                ins_p1 <= data; // Store the instruction in ins_p1
            end
            2'b10: begin // If fetch is 2'b10, update ins_p2
                ins_p2 <= data; // Store the instruction in ins_p2
            end
            default: begin // If neither condition is met, retain previous values
                ins_p1 <= ins_p1; // Retain the value of ins_p1
                ins_p2 <= ins_p2; // Retain the value of ins_p2
            end
        endcase
    end
end

assign ins = ins_p1[7:5]; // Derive ins from the high 3 bits of ins_p1
assign ad1 = ins_p1[4:0]; // Derive ad1 from the low 5 bits of ins_p1
assign ad2 = ins_p2; // Derive ad2 from the full 8 bits of ins_p2

endmodule