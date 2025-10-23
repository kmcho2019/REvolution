module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline registers for enable signal (3 stages)
    reg [2:0] mul_en_pipe;

    // Registers for input operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Register for final product output
    reg [15:0] mul_out_reg;

    // Sample inputs and shift enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 3'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products combinationally
    wire [15:0] partial_products[7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i +1) begin : gen_pp
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Sum all partial products combinationally
    wire [15:0] sum_partial = partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3]
                             + partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];

    // Register final product when partial sums are valid (aligned with pipeline)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_pipe[1])
            mul_out_reg <= sum_partial;
        else
            mul_out_reg <= 16'd0;
    end

    // Output enable indicates product validity at output stage
    assign mul_en_out = mul_en_pipe[2];

    // Output product: valid when enable asserted, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule