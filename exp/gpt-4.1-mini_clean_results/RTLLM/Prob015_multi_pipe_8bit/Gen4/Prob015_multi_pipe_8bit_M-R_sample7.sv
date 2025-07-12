module multi_pipe_8bit (
    input             clk,
    input             rst_n,
    input             mul_en_in,
    input      [7:0]  mul_a,
    input      [7:0]  mul_b,
    output reg        mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline enable registers: stage 0 to stage 4
reg [4:0] mul_en_pipe;

// Stage 0: input registers for operands
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products (16-bit each) generated combinationally from inputs
wire [15:0] partial_prod [7:0];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
        assign partial_prod[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Pipeline stage 1: sum pairs of partial products into 4 sums
reg [15:0] sum_stage1 [3:0];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1[0] <= 16'd0;
        sum_stage1[1] <= 16'd0;
        sum_stage1[2] <= 16'd0;
        sum_stage1[3] <= 16'd0;
    end else if (mul_en_pipe[0]) begin
        sum_stage1[0] <= partial_prod[0] + partial_prod[1];
        sum_stage1[1] <= partial_prod[2] + partial_prod[3];
        sum_stage1[2] <= partial_prod[4] + partial_prod[5];
        sum_stage1[3] <= partial_prod[6] + partial_prod[7];
    end else begin
        sum_stage1[0] <= 16'd0;
        sum_stage1[1] <= 16'd0;
        sum_stage1[2] <= 16'd0;
        sum_stage1[3] <= 16'd0;
    end
end

// Pipeline stage 2: sum pairs of stage1 sums into 2 sums
reg [15:0] sum_stage2 [1:0];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2[0] <= 16'd0;
        sum_stage2[1] <= 16'd0;
    end else if (mul_en_pipe[1]) begin
        sum_stage2[0] <= sum_stage1[0] + sum_stage1[1];
        sum_stage2[1] <= sum_stage1[2] + sum_stage1[3];
    end else begin
        sum_stage2[0] <= 16'd0;
        sum_stage2[1] <= 16'd0;
    end
end

// Pipeline stage 3: sum the two stage2 sums into final product
reg [15:0] product_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product_reg <= 16'd0;
    end else if (mul_en_pipe[2]) begin
        product_reg <= sum_stage2[0] + sum_stage2[1];
    end else begin
        product_reg <= 16'd0;
    end
end

// Input capture and enable pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_pipe <= 5'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else begin
        mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Output enable from last pipeline stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
    end else begin
        mul_en_out <= mul_en_pipe[3];
    end
end

// Output register assignment (registered mux)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'd0;
    end else if (mul_en_pipe[3]) begin
        mul_out <= product_reg;
    end else begin
        mul_out <= 16'd0;
    end
end

endmodule