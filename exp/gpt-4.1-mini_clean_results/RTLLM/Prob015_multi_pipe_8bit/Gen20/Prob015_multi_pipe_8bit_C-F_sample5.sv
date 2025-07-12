module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Pipeline registers for enable signals (2-stage)
    reg [1:0] mul_en_pipe;

    // Input registers for multiplicand and multiplier
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires (16-bit each)
    wire [15:0] partial_products [7:0];

    genvar idx;
    generate
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial_products
            // Generate partial products only when input enable is active
            assign partial_products[idx] = (mul_en_pipe[0] && mul_b_reg[idx]) ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // Summation of all partial products - combinational logic
    wire [15:0] partial_sum = partial_products[0] + partial_products[1] + partial_products[2] +
                              partial_products[3] + partial_products[4] + partial_products[5] +
                              partial_products[6] + partial_products[7];

    // Register to store final product
    reg [15:0] mul_out_reg;

    // Sequential logic: sample inputs, track enable, register product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 2'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_out_reg <= 16'd0;
            mul_en_out <= 1'b0;
            mul_out <= 16'd0;
        end else begin
            // Shift enable pipeline and sample inputs only if mul_en_in is asserted
            mul_en_pipe <= {mul_en_pipe[0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Register partial sum on the second pipeline stage enable
            if (mul_en_pipe[1]) begin
                mul_out_reg <= partial_sum;
            end else begin
                mul_out_reg <= 16'd0;
            end

            // Update output enable and output product registers
            mul_en_out <= mul_en_pipe[1];
            mul_out <= mul_en_pipe[1] ? mul_out_reg : 16'd0;
        end
    end

endmodule