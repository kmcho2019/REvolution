module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Packed 16-bit register storing both instructions
    reg [15:0] packed_reg;

    // Output registers
    reg [2:0] ins_reg;
    reg [4:0] ad1_reg;
    reg [7:0] ad2_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Selective reset - only clear relevant bits
            packed_reg <= 16'b0;
            ins_reg <= 3'b0;
            ad1_reg <= 5'b0;
            ad2_reg <= 8'b0;
        end
        else begin
            // Update packed register based on fetch signal
            case (fetch)
                2'b01: packed_reg[7:0] <= data;    // Update lower byte
                2'b10: packed_reg[15:8] <= data;   // Update upper byte
                default: ;                         // No update
            endcase

            // Registered outputs (improves timing)
            ins_reg <= packed_reg[10:8];  // Bits [10:8] of lower byte
            ad1_reg <= packed_reg[4:0];   // Bits [4:0] of lower byte
            ad2_reg <= packed_reg[15:8];  // Upper byte
        end
    end

    // Continuous assignments to outputs
    assign ins = ins_reg;
    assign ad1 = ad1_reg;
    assign ad2 = ad2_reg;

endmodule