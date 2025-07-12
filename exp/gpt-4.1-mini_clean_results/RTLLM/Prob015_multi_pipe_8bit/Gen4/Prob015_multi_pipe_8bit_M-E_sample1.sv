module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline enable registers - 4-stage pipeline
reg [3:0] mul_en_pipe;

// Input registers for multiplicand and multiplier
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Stage 1: Partial products (8 partial products, 16-bit each)
wire [15:0] pp [7:0];
genvar i;
generate
    for (i=0; i<8; i=i+1) begin: PP_GEN
        assign pp[i] = mul_b_reg[i] ? ( {8'd0, mul_a_reg} << i ) : 16'd0;
    end
endgenerate

// Stage 2 registers: Sum pairs of partial products -> 4 sums
reg [15:0] sum_stage2 [3:0];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2[0] <= 16'd0;
        sum_stage2[1] <= 16'd0;
        sum_stage2[2] <= 16'd0;
        sum_stage2[3] <= 16'd0;
    end else if (mul_en_pipe[0]) begin
        sum_stage2[0] <= pp[0] + pp[1];
        sum_stage2[1] <= pp[2] + pp[3];
        sum_stage2[2] <= pp[4] + pp[5];
        sum_stage2[3] <= pp[6] + pp[7];
    end else begin
        sum_stage2[0] <= 16'd0;
        sum_stage2[1] <= 16'd0;
        sum_stage2[2] <= 16'd0;
        sum_stage2[3] <= 16'd0;
    end
end

// Stage 3 registers: Sum pairs of stage2 sums -> 2 sums
reg [15:0] sum_stage3 [1:0];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3[0] <= 16'd0;
        sum_stage3[1] <= 16'd0;
    end else if (mul_en_pipe[1]) begin
        sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
        sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
    end else begin
        sum_stage3[0] <= 16'd0;
        sum_stage3[1] <= 16'd0;
    end
end

// Stage 4 register: Sum final two sums -> product
reg [15:0] product_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product_reg <= 16'd0;
    end else if (mul_en_pipe[2]) begin
        product_reg <= sum_stage3[0] + sum_stage3[1];
    end else begin
        product_reg <= 16'd0;
    end
end

// Input registers and enable pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_en_pipe <= 4'b0;
    end else begin
        // Shift enable pipeline
        mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
        // Register inputs when input enable asserted
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Output enable aligned with final product stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
    end else begin
        mul_en_out <= mul_en_pipe[3];
    end
end

// Output mux: valid product when output enable asserted, else 0
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'd0;
    end else if (mul_en_out) begin
        mul_out <= product_reg;
    end else begin
        mul_out <= 16'd0;
    end
end

endmodule