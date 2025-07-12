module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline registers for enable signals (3 stages)
    reg [2:0] mul_en_pipe;

    // Input registers for operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires
    wire [15:0] partial_products[7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 1 partial sums registers
    reg [15:0] sum_low_reg;   // sum of partial_products[0..3]
    reg [15:0] sum_high_reg;  // sum of partial_products[4..7]

    // Stage 2 final product register
    reg [15:0] mul_out_reg;

    // Pipeline enable signals update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 3'b0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};
        end
    end

    // Input operands register, sampled when mul_en_in is asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 1: sum partial products in two groups combinationally, then register them
    wire [15:0] sum_low  = partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
    wire [15:0] sum_high = partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_low_reg  <= 16'd0;
            sum_high_reg <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            sum_low_reg  <= sum_low;
            sum_high_reg <= sum_high;
        end else begin
            sum_low_reg  <= 16'd0;
            sum_high_reg <= 16'd0;
        end
    end

    // Stage 2: sum the two registered partial sums and register final product
    wire [15:0] sum_final = sum_low_reg + sum_high_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            mul_out_reg <= sum_final;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable corresponds to the enable signal propagated through the pipeline
    assign mul_en_out = mul_en_pipe[2];

    // Output product is valid only when mul_en_out is asserted
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule