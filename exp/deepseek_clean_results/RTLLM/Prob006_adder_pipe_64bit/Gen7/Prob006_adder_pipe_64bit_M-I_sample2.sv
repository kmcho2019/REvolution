module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [31:0] adda_hi_reg, addb_hi_reg;  // Upper 32-bit operands
reg [32:0] sum_lo_reg;                // Lower 32-bit sum + carry
reg en_pipeline;                      // Single enable pipeline register

// Combinational sums
wire [32:0] sum_lo = adda[31:0] + addb[31:0];          // Lower sum
wire [32:0] sum_hi = adda_hi_reg + addb_hi_reg + sum_lo_reg[32]; // Upper sum with carry

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all registers on reset
        {adda_hi_reg, addb_hi_reg} <= 64'b0;
        sum_lo_reg <= 33'b0;
        en_pipeline <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Capture lower sum and upper operands
        sum_lo_reg <= sum_lo;
        adda_hi_reg <= adda[63:32];
        addb_hi_reg <= addb[63:32];
        en_pipeline <= i_en;
        
        // Stage 2: Combine results
        if (en_pipeline) begin
            result <= {sum_hi[32], sum_hi[31:0], sum_lo_reg[31:0]};
        end
        o_en <= en_pipeline;
    end
end

endmodule