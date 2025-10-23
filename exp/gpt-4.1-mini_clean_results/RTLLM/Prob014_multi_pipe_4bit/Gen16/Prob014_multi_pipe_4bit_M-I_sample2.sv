module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                         clk,
    input                         rst_n,      // Active low synchronous reset
    input       [size-1:0]        mul_a,
    input       [size-1:0]        mul_b,
    output reg  [product_width-1:0] mul_out
);

    // Zero-extend mul_a by size bits on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // --------------------
    // Stage 1: Partial Products generation combinationally for each bit of mul_b
    wire [product_width-1:0] pp0 = mul_b[0] ? (mul_a_ext << 0) : {product_width{1'b0}};
    wire [product_width-1:0] pp1 = mul_b[1] ? (mul_a_ext << 1) : {product_width{1'b0}};
    wire [product_width-1:0] pp2 = mul_b[2] ? (mul_a_ext << 2) : {product_width{1'b0}};
    wire [product_width-1:0] pp3 = mul_b[3] ? (mul_a_ext << 3) : {product_width{1'b0}};

    // Pipeline registers stage 1: register each partial product separately
    reg [product_width-1:0] pp_reg0, pp_reg1, pp_reg2, pp_reg3;

    always @(posedge clk) begin
        if (~rst_n) begin
            pp_reg0 <= {product_width{1'b0}};
            pp_reg1 <= {product_width{1'b0}};
            pp_reg2 <= {product_width{1'b0}};
            pp_reg3 <= {product_width{1'b0}};
        end else begin
            pp_reg0 <= pp0;
            pp_reg1 <= pp1;
            pp_reg2 <= pp2;
            pp_reg3 <= pp3;
        end
    end

    // --------------------
    // Stage 2: Sum partial products pairwise and register

    // Pairwise sums
    wire [product_width-1:0] sum_pair0 = pp_reg0 + pp_reg1;
    wire [product_width-1:0] sum_pair1 = pp_reg2 + pp_reg3;

    // Pipeline registers stage 2: register sums of pairs
    reg [product_width-1:0] sum_pair_reg0, sum_pair_reg1;

    always @(posedge clk) begin
        if (~rst_n) begin
            sum_pair_reg0 <= {product_width{1'b0}};
            sum_pair_reg1 <= {product_width{1'b0}};
        end else begin
            sum_pair_reg0 <= sum_pair0;
            sum_pair_reg1 <= sum_pair1;
        end
    end

    // --------------------
    // Stage 3: Final sum registered output

    wire [product_width-1:0] final_sum = sum_pair_reg0 + sum_pair_reg1;

    always @(posedge clk) begin
        if (~rst_n) begin
            mul_out <= {product_width{1'b0}};
        end else begin
            mul_out <= final_sum;
        end
    end

endmodule