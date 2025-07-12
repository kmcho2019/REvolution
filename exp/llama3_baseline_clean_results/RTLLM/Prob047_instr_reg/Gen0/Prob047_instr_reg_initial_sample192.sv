module instr_reg(
    input clk, // Clock signal
    input rst_n, // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data, // 8-bit data input representing the instruction
    output [2:0] ins, // High 3 bits of the instruction (opcode)
    output [4:0] ad1, // Low 5 bits of the instruction (register address)
    output [7:0] ad2 // Full 8-bit data from the second source
);

reg [7:0] ins_p1; // First 8-bit register to store instructions
reg [7:0] ins_p2; // Second 8-bit register to store instructions

// Clock-synchronized process to update the registers
always @(posedge clk) begin
    if (~rst_n) begin // Reset condition
        ins_p1 <= 8'b0; // Initialize ins_p1 to zero
        ins_p2 <= 8'b0; // Initialize ins_p2 to zero
    end else begin
        case (fetch) // Update registers based on the fetch signal
            2'b01: begin // Fetch from data input into ins_p1
                ins_p1 <= data;
            end
            2'b10: begin // Fetch from data input into ins_p2
                ins_p2 <= data;
            end
            default: begin // Retain previous values if fetch is not 2'b01 or 2'b10
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

// Combinational logic to derive output signals
assign ins = ins_p1[7:5]; // High 3 bits of ins_p1 (opcode)
assign ad1 = ins_p1[4:0]; // Low 5 bits of ins_p1 (register address)
assign ad2 = ins_p2; // Full 8-bit data from ins_p2 (second source)

endmodule