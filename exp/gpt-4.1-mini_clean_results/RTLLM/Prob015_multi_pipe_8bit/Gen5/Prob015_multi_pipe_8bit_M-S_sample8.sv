module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Enable pipeline: 3 stages (input, product calc, output)
    reg [2:0] mul_en_pipe;

    // Input registers for operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Register to hold final product
    reg [15:0] mul_out_reg;

    integer i;

    // Sample inputs and propagate enable
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

    // Partial product generation combinationally
    wire [15:0] partial_products[7:0];
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // Sum all partial products combinationally
    wire [15:0] sum_partial;
    assign sum_partial = partial_products[0] + partial_products[1] + partial_products[2] +
                         partial_products[3] + partial_products[4] + partial_products[5] +
                         partial_products[6] + partial_products[7];

    // Register final product when partial sums are valid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            mul_out_reg <= sum_partial;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable indicates valid product at mul_out_reg
    assign mul_en_out = mul_en_pipe[2];

    // Output mux: zero when output not valid
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule