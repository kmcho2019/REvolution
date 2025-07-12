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
    // Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires
    wire [15:0] partial_products [7:0];
    integer i;

    // Register inputs and enable signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 2'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products by ANDing mul_a_reg with each bit of mul_b_reg shifted accordingly
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial_products
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // Sum all partial products in a combinational way
    wire [15:0] partial_sum;
    assign partial_sum = partial_products[0] + partial_products[1] + partial_products[2] +
                         partial_products[3] + partial_products[4] + partial_products[5] +
                         partial_products[6] + partial_products[7];

    // Register the final product
    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            mul_out_reg <= partial_sum;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable and product signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe[1];
    end

    always @(*) begin
        mul_out = mul_en_out ? mul_out_reg : 16'd0;
    end

endmodule