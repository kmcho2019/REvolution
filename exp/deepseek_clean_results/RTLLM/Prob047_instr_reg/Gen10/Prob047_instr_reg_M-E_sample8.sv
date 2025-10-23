module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2,
    input en,        // Enable signal for power saving
    input shift      // Shift control signal
);

    // Single 16-bit register to store both instructions
    reg [15:0] instr_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_reg <= 16'b0;
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else if (en) begin
            // Shift operation takes priority
            if (shift) begin
                instr_reg <= {instr_reg[7:0], 8'b0}; // Right shift by 8 bits
            end
            // Parallel load operations
            else case (fetch)
                2'b01: instr_reg[15:8] <= data;  // Load first part
                2'b10: instr_reg[7:0] <= data;   // Load second part
                default: instr_reg <= instr_reg;  // Hold current value
            endcase

            // Update outputs (could be registered or combinational)
            ins <= instr_reg[15:13];
            ad1 <= instr_reg[12:8];
            ad2 <= instr_reg[7:0];
        end
    end

endmodule