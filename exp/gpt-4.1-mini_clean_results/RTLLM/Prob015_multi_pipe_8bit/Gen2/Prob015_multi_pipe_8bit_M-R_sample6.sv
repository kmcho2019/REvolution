module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline register for input enable signal (4 stages)
reg [3:0] mul_en_pipe;

// Input registers for operands
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products wires (8 partial products)
wire [15:0] partial_products [7:0];

genvar i;
generate
    for(i = 0; i < 8; i = i + 1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Pipeline registers for partial sums
reg [15:0] stage1_sum0; // sum of partial_products[0] + partial_products[1]
reg [15:0] stage1_sum1; // sum of partial_products[2] + partial_products[3]
reg [15:0] stage1_sum2; // sum of partial_products[4] + partial_products[5]
reg [15:0] stage1_sum3; // sum of partial_products[6] + partial_products[7]

reg [15:0] stage2_sum0; // sum of stage1_sum0 + stage1_sum1
reg [15:0] stage2_sum1; // sum of stage1_sum2 + stage1_sum3

reg [15:0] stage3_sum;  // sum of stage2_sum0 + stage2_sum1

// Input stage: capture inputs and shift mul_en_in
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_pipe <= 4'b0000;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else begin
        mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Stage 1: sum pairs of partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum0 <= 16'd0;
        stage1_sum1 <= 16'd0;
        stage1_sum2 <= 16'd0;
        stage1_sum3 <= 16'd0;
    end else if (mul_en_pipe[0]) begin
        stage1_sum0 <= partial_products[0] + partial_products[1];
        stage1_sum1 <= partial_products[2] + partial_products[3];
        stage1_sum2 <= partial_products[4] + partial_products[5];
        stage1_sum3 <= partial_products[6] + partial_products[7];
    end else begin
        stage1_sum0 <= 16'd0;
        stage1_sum1 <= 16'd0;
        stage1_sum2 <= 16'd0;
        stage1_sum3 <= 16'd0;
    end
end

// Stage 2: sum results of stage 1 pairs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum0 <= 16'd0;
        stage2_sum1 <= 16'd0;
    end else if (mul_en_pipe[1]) begin
        stage2_sum0 <= stage1_sum0 + stage1_sum1;
        stage2_sum1 <= stage1_sum2 + stage1_sum3;
    end else begin
        stage2_sum0 <= 16'd0;
        stage2_sum1 <= 16'd0;
    end
end

// Stage 3: final sum to get the product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_sum <= 16'd0;
    end else if (mul_en_pipe[2]) begin
        stage3_sum <= stage2_sum0 + stage2_sum1;
    end else begin
        stage3_sum <= 16'd0;
    end
end

// Output stage: latch output and output enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'd0;
        mul_en_out <= 1'b0;
    end else begin
        mul_en_out <= mul_en_pipe[3];
        if (mul_en_pipe[3])
            mul_out <= stage3_sum;
        else
            mul_out <= 16'd0;
    end
end

endmodule