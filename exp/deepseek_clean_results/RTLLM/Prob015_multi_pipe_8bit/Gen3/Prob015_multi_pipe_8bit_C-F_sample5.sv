module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline stage registers
reg [7:0] a_reg, b_reg;
reg [2:0] en_pipe;  // 3-bit enable pipeline

// Partial products with operand isolation
wire [15:0] pp [0:7];
wire pp_en = en_pipe[0];

// Generate partial products only when enabled
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pp_gen
        assign pp[i] = pp_en ? (b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0) : 16'b0;
    end
endgenerate

// Pipeline stage 1: First level additions (8 -> 4)
reg [15:0] sum1_0, sum1_1, sum1_2, sum1_3;

// Pipeline stage 2: Second level additions (4 -> 2)
reg [15:0] sum2_0, sum2_1;

// Pipeline stage 3: Final addition (2 -> 1)
reg [15:0] final_sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Only reset essential registers
        a_reg <= 8'b0;
        b_reg <= 8'b0;
        en_pipe <= 3'b0;
        
        sum1_0 <= 16'b0;
        sum1_1 <= 16'b0;
        sum1_2 <= 16'b0;
        sum1_3 <= 16'b0;
        
        sum2_0 <= 16'b0;
        sum2_1 <= 16'b0;
        
        final_sum <= 16'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end
    else begin
        // Stage 0: Input registration
        en_pipe[0] <= mul_en_in;
        if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end

        // Stage 1: First level additions (8 -> 4)
        en_pipe[1] <= en_pipe[0];
        sum1_0 <= pp[0] + pp[1];
        sum1_1 <= pp[2] + pp[3];
        sum1_2 <= pp[4] + pp[5];
        sum1_3 <= pp[6] + pp[7];

        // Stage 2: Second level additions (4 -> 2)
        en_pipe[2] <= en_pipe[1];
        sum2_0 <= sum1_0 + sum1_1;
        sum2_1 <= sum1_2 + sum1_3;

        // Stage 3: Final addition (2 -> 1)
        final_sum <= sum2_0 + sum2_1;
        mul_en_out <= en_pipe[2];
        
        // Output with operand isolation
        mul_out <= en_pipe[2] ? final_sum : 16'b0;
    end
end

endmodule