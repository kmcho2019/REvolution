module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Unified 16-bit instruction register
    reg [15:0] instr_reg;

    // Write control logic
    wire write_enable = |fetch;
    wire [1:0] write_sel = fetch;
    wire [15:0] write_data = {2{data}}; // Replicate data for both positions

    // Main register update
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instr_reg <= 16'h0000;
        end else if (write_enable) begin
            case (write_sel)
                2'b01: instr_reg[7:0] <= write_data[7:0];   // Update lower byte
                2'b10: instr_reg[15:8] <= write_data[15:8]; // Update upper byte
                default: ; // No update
            endcase
        end
    end

    // Output registers for better timing
    always @(posedge clk) begin
        ins <= instr_reg[7:5];  // Upper 3 bits of lower byte
        ad1 <= instr_reg[4:0];  // Lower 5 bits of lower byte
        ad2 <= instr_reg[15:8]; // Full upper byte
    end

endmodule