module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage registers
reg [31:0] adda_hi_reg, addb_hi_reg;
reg [32:0] sum_lo_reg;  // Includes carry out
reg en_stg1, en_stg2;

// Combinational logic wires
wire [32:0] sum_lo = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};
wire [32:0] sum_hi = {1'b0, adda_hi_reg} + {1'b0, addb_hi_reg} + sum_lo_reg[32];

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        adda_hi_reg <= 32'b0;
        addb_hi_reg <= 32'b0;
        sum_lo_reg <= 33'b0;
        en_stg1 <= 1'b0;
        en_stg2 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Capture lower sum and upper operands
        sum_lo_reg <= sum_lo;
        adda_hi_reg <= adda[63:32];
        addb_hi_reg <= addb[63:32];
        en_stg1 <= i_en;
        
        // Stage 2: Combine results and generate output
        en_stg2 <= en_stg1;
        result <= {sum_hi[31:0], sum_lo_reg[31:0]};
        result[64] <= sum_hi[32];  // Final carry out
        o_en <= en_stg2;
    end
end

endmodule