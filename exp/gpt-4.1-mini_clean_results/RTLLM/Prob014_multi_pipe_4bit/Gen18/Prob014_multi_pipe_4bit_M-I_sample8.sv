module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                       clk,
    input                       rst_n,      // Active low reset
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [product_width-1:0] mul_out
);

    // Extend multiplicand by adding size zeros on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally for each bit of mul_b
    wire [product_width-1:0] partial_product_0 = mul_b[0] ? (mul_a_ext << 0) : {product_width{1'b0}};
    wire [product_width-1:0] partial_product_1 = mul_b[1] ? (mul_a_ext << 1) : {product_width{1'b0}};
    wire [product_width-1:0] partial_product_2 = mul_b[2] ? (mul_a_ext << 2) : {product_width{1'b0}};
    wire [product_width-1:0] partial_product_3 = mul_b[3] ? (mul_a_ext << 3) : {product_width{1'b0}};

    // Stage 1 registers: latch partial products
    reg [product_width-1:0] stage1_pp0;
    reg [product_width-1:0] stage1_pp1;
    reg [product_width-1:0] stage1_pp2;
    reg [product_width-1:0] stage1_pp3;

    // Stage 2 registers: latch partial sums and output pipeline register
    reg [product_width-1:0] stage2_sum;
    reg [product_width-1:0] stage2_sum_d;  // delayed sum for output register

    // Sequential logic: Stage 1 registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_pp0 <= {product_width{1'b0}};
            stage1_pp1 <= {product_width{1'b0}};
            stage1_pp2 <= {product_width{1'b0}};
            stage1_pp3 <= {product_width{1'b0}};
        end else begin
            stage1_pp0 <= partial_product_0;
            stage1_pp1 <= partial_product_1;
            stage1_pp2 <= partial_product_2;
            stage1_pp3 <= partial_product_3;
        end
    end

    // Combinational addition inside stage 2: balanced addition to reduce adder delay
    wire [product_width-1:0] sum01 = stage1_pp0 + stage1_pp1;
    wire [product_width-1:0] sum23 = stage1_pp2 + stage1_pp3;
    wire [product_width-1:0] final_sum = sum01 + sum23;

    // Sequential logic: Stage 2 registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {product_width{1'b0}};
            stage2_sum_d <= {product_width{1'b0}};
            mul_out <= {product_width{1'b0}};
        end else begin
            stage2_sum <= final_sum;
            stage2_sum_d <= stage2_sum;
            mul_out <= stage2_sum_d;
        end
    end

endmodule