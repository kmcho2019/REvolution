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
reg [63:0] a_reg, b_reg;          // Stage 1 operand registers
reg [63:32] a_upper, b_upper;     // Stage 2 upper bits
reg [32:0] sum_lower;             // Lower 32-bit sum + carry
reg [32:0] sum_upper;             // Upper 32-bit sum + carry
reg [1:0] en_pipe;                // Enable pipeline

// Clock gating signals
wire clk_gated = clk & (i_en | |en_pipe);

// Combinational sums
wire [32:0] sum_lower_comb = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};
wire [32:0] sum_upper_comb = {1'b0, a_upper} + {1'b0, b_upper} + sum_lower[32];

always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        // Conditional reset (only reset if i_en is active)
        if (i_en) begin
            a_reg <= 64'b0;
            b_reg <= 64'b0;
            a_upper <= 32'b0;
            b_upper <= 32'b0;
            sum_lower <= 33'b0;
            sum_upper <= 33'b0;
            en_pipe <= 2'b0;
        end
    end else begin
        // Stage 1: Register inputs and compute lower sum
        a_reg <= adda;
        b_reg <= addb;
        sum_lower <= sum_lower_comb;
        
        // Stage 2: Register upper bits and compute final sum
        a_upper <= a_reg[63:32];
        b_upper <= b_reg[63:32];
        sum_upper <= sum_upper_comb;
        
        // Pipeline the enable signal
        en_pipe <= {en_pipe[0], i_en};
    end
end

// Output stage (registered for better timing)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {sum_upper[32], sum_upper[31:0], sum_lower[31:0]};
        o_en <= en_pipe[1];
    end
end

endmodule