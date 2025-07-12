module multi_pipe_8bit (
    input             clk,
    input             rst_n,
    input             mul_en_in,
    input      [7:0]  mul_a,
    input      [7:0]  mul_b,
    output reg        mul_en_out,
    output reg [15:0] mul_out
);

// Stage 1 registers - input latch and partial product generation
reg [7:0]  mul_a_s1;
reg [7:0]  mul_b_s1;
reg        mul_en_s1;
wire [15:0] partial_products [7:0];

genvar i;
generate
    for(i=0; i<8; i=i+1) begin : gen_partial_products
        assign partial_products[i] = mul_b_s1[i] ? (mul_a_s1 << i) : 16'd0;
    end
endgenerate

// Stage 2 registers - pairwise sum of partial products (4 sums)
reg [15:0] sum_s2_0, sum_s2_1, sum_s2_2, sum_s2_3;
reg        mul_en_s2;

// Stage 3 registers - sum pairs of sums from stage 2 (2 sums)
reg [15:0] sum_s3_0, sum_s3_1;
reg        mul_en_s3;

// Stage 4 registers - final sum and output enable
reg [15:0] product_s4;
reg        mul_en_s4;

// Pipeline Stage 1: Latch inputs and generate partial products sums for next stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_s1   <= 8'd0;
        mul_b_s1   <= 8'd0;
        mul_en_s1  <= 1'b0;
    end else begin
        mul_en_s1  <= mul_en_in;
        if (mul_en_in) begin
            mul_a_s1 <= mul_a;
            mul_b_s1 <= mul_b;
        end else begin
            mul_a_s1 <= 8'd0;
            mul_b_s1 <= 8'd0;
        end
    end
end

// Pipeline Stage 2: Add partial products in pairs of two
// sums: 0+1, 2+3, 4+5, 6+7
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_s2_0  <= 16'd0;
        sum_s2_1  <= 16'd0;
        sum_s2_2  <= 16'd0;
        sum_s2_3  <= 16'd0;
        mul_en_s2 <= 1'b0;
    end else begin
        if (mul_en_s1) begin
            sum_s2_0 <= partial_products[0] + partial_products[1];
            sum_s2_1 <= partial_products[2] + partial_products[3];
            sum_s2_2 <= partial_products[4] + partial_products[5];
            sum_s2_3 <= partial_products[6] + partial_products[7];
        end else begin
            sum_s2_0 <= 16'd0;
            sum_s2_1 <= 16'd0;
            sum_s2_2 <= 16'd0;
            sum_s2_3 <= 16'd0;
        end
        mul_en_s2 <= mul_en_s1;
    end
end

// Pipeline Stage 3: Add sums from stage 2 in pairs: (0+1), (2+3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_s3_0  <= 16'd0;
        sum_s3_1  <= 16'd0;
        mul_en_s3 <= 1'b0;
    end else begin
        if (mul_en_s2) begin
            sum_s3_0 <= sum_s2_0 + sum_s2_1;
            sum_s3_1 <= sum_s2_2 + sum_s2_3;
        end else begin
            sum_s3_0 <= 16'd0;
            sum_s3_1 <= 16'd0;
        end
        mul_en_s3 <= mul_en_s2;
    end
end

// Pipeline Stage 4: Final sum and output enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product_s4  <= 16'd0;
        mul_en_s4  <= 1'b0;
        mul_en_out <= 1'b0;
        mul_out    <= 16'd0;
    end else begin
        if (mul_en_s3) begin
            product_s4 <= sum_s3_0 + sum_s3_1;
        end else begin
            product_s4 <= 16'd0;
        end
        mul_en_s4  <= mul_en_s3;

        mul_en_out <= mul_en_s4;
        mul_out    <= mul_en_s4 ? product_s4 : 16'd0;
    end
end

endmodule