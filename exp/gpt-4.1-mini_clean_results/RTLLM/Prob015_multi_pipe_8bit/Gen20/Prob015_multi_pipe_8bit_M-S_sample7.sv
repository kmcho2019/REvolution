module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline shift register for enable tracking (3 cycles latency)
    reg [2:0] mul_en_pipe;

    // Input operand registers
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

    // Sum of partial products combinationally
    wire [15:0] sum_partial;
    assign sum_partial = partial_products[0] + partial_products[1] + partial_products[2] +
                         partial_products[3] + partial_products[4] + partial_products[5] +
                         partial_products[6] + partial_products[7];

    // Output product register
    reg [15:0] mul_out_reg;

    // Enable pipeline shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 3'b0;
        else
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};
    end

    // Register inputs when input enable asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Register output product when middle pipeline stage valid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_pipe[1])
            mul_out_reg <= sum_partial;
        else
            mul_out_reg <= 16'd0;
    end

    // Output enable signal from MSB of pipeline register
    assign mul_en_out = mul_en_pipe[2];

    // Output product is valid only when output enable is asserted
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule