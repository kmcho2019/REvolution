module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Parameterized length for enable pipeline stages
localparam PIPE_STAGES = 4;

// Enable signal pipeline as a shift register module (internal)
reg [PIPE_STAGES-1:0] mul_en_pipe;

// Input operand registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products wires: each partial product is mul_a_reg shifted by bit position i if mul_b_reg[i] is set
wire [15:0] partial_products [7:0];

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_partials
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Pipeline registers for partial sums at stage 1
reg [15:0] sum_stage1_0, sum_stage1_1, sum_stage1_2;

// Pipeline registers for partial sums at stage 2
reg [15:0] sum_stage2_0, sum_stage2_1;

// Pipeline register for final product
reg [15:0] product_reg;

// Combinational sums for stage 1 groups
wire [15:0] sum0_stage1 = partial_products[0] + partial_products[1] + partial_products[2];
wire [15:0] sum1_stage1 = partial_products[3] + partial_products[4] + partial_products[5];
wire [15:0] sum2_stage1 = partial_products[6] + partial_products[7];

// Combinational sums for stage 2
wire [15:0] sum0_stage2 = sum_stage1_0 + sum_stage1_1;
// sum_stage1_2 is forwarded as sum_stage2_1

// Combinational sum for stage 3 (final)
wire [15:0] final_sum = sum_stage2_0 + sum_stage2_1;

// Enable pipeline shift register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_pipe <= {PIPE_STAGES{1'b0}};
    end else begin
        mul_en_pipe <= {mul_en_pipe[PIPE_STAGES-2:0], mul_en_in};
    end
end

// Input operand registers with enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Stage 1 pipeline registers for partial sums
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1_0 <= 16'd0;
        sum_stage1_1 <= 16'd0;
        sum_stage1_2 <= 16'd0;
    end else if (mul_en_pipe[0]) begin
        sum_stage1_0 <= sum0_stage1;
        sum_stage1_1 <= sum1_stage1;
        sum_stage1_2 <= sum2_stage1;
    end else begin
        sum_stage1_0 <= 16'd0;
        sum_stage1_1 <= 16'd0;
        sum_stage1_2 <= 16'd0;
    end
end

// Stage 2 pipeline registers for sums
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2_0 <= 16'd0;
        sum_stage2_1 <= 16'd0;
    end else if (mul_en_pipe[1]) begin
        sum_stage2_0 <= sum0_stage2;
        sum_stage2_1 <= sum_stage1_2;
    end else begin
        sum_stage2_0 <= 16'd0;
        sum_stage2_1 <= 16'd0;
    end
end

// Stage 3 pipeline register for final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product_reg <= 16'd0;
    end else if (mul_en_pipe[2]) begin
        product_reg <= final_sum;
    end else begin
        product_reg <= 16'd0;
    end
end

// Output enable and product output registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'd0;
    end else begin
        mul_en_out <= mul_en_pipe[3];
        mul_out <= mul_en_pipe[3] ? product_reg : 16'd0;
    end
end

endmodule