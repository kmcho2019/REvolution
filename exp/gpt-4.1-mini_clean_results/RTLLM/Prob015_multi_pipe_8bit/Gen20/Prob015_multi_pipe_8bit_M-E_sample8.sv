module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Stage 1 registers
reg        stage1_en;
reg [7:0]  stage1_a;
reg [7:0]  stage1_b;
wire [15:0] partial_products [7:0];

// Generate partial products in Stage 1 combinationally based on registered inputs
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial
        assign partial_products[i] = (stage1_en && stage1_b[i]) ? (stage1_a << i) : 16'd0;
    end
endgenerate

// Stage 2 registers - sum pairs of partial products
reg         stage2_en;
reg [15:0]  stage2_sum[3:0]; // 4 sums of two partial products each

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_en <= 1'b0;
        stage2_sum[0] <= 16'd0;
        stage2_sum[1] <= 16'd0;
        stage2_sum[2] <= 16'd0;
        stage2_sum[3] <= 16'd0;
    end else begin
        stage2_en <= stage1_en;
        stage2_sum[0] <= partial_products[0] + partial_products[1];
        stage2_sum[1] <= partial_products[2] + partial_products[3];
        stage2_sum[2] <= partial_products[4] + partial_products[5];
        stage2_sum[3] <= partial_products[6] + partial_products[7];
    end
end

// Stage 3 registers - sum pairs from Stage 2
reg         stage3_en;
reg [15:0]  stage3_sum[1:0]; // 2 sums

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_en <= 1'b0;
        stage3_sum[0] <= 16'd0;
        stage3_sum[1] <= 16'd0;
    end else begin
        stage3_en <= stage2_en;
        stage3_sum[0] <= stage2_sum[0] + stage2_sum[1];
        stage3_sum[1] <= stage2_sum[2] + stage2_sum[3];
    end
end

// Final stage register - produce the final product and output enable
reg         stage4_en;
reg [15:0]  product_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage4_en  <= 1'b0;
        product_reg <= 16'd0;
        mul_en_out <= 1'b0;
        mul_out    <= 16'd0;
    end else begin
        stage4_en  <= stage3_en;
        product_reg <= stage3_sum[0] + stage3_sum[1];
        mul_en_out <= stage4_en;
        mul_out <= stage4_en ? product_reg : 16'd0;
    end
end

// Input stage registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_en <= 1'b0;
        stage1_a  <= 8'd0;
        stage1_b  <= 8'd0;
    end else begin
        stage1_en <= mul_en_in;
        if (mul_en_in) begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
        end
    end
end

endmodule