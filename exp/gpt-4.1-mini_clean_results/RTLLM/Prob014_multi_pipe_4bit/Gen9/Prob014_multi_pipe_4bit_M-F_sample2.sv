module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended size: double input size to hold extended multiplicand and full product
    localparam ext_size = size * 2;

    // Stage 1 registers: extended multiplicand and multiplier bits registered
    reg [ext_size-1:0] reg_ext_mul_a;
    reg [size-1:0]     reg_mul_b;

    // Partial products generated per bit of reg_mul_b after stage 1 registers
    reg [ext_size-1:0] partial_products [size-1:0];

    // Stage 2 register: sum of partial products
    reg [2*size-1:0] sum_partials;

    integer i;

    // Stage 1: Register extended multiplicand and multiplier bits on clk, async reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_ext_mul_a <= {ext_size{1'b0}};
            reg_mul_b     <= {size{1'b0}};
        end else begin
            // Extend mul_a by size zeros on MSB side, concatenation: zeros first, then mul_a
            reg_ext_mul_a <= {{size{1'b0}}, mul_a};
            reg_mul_b     <= mul_b;
        end
    end

    // Generate partial products combinationally based on stage 1 registered inputs
    // For each bit i of reg_mul_b:
    //  If bit is 1, partial product = reg_ext_mul_a shifted left by i
    //  Else partial product = 0
    always @(*) begin
        for (i = 0; i < size; i = i + 1) begin
            if (reg_mul_b[i])
                partial_products[i] = reg_ext_mul_a << i;
            else
                partial_products[i] = {ext_size{1'b0}};
        end
    end

    // Stage 2: On clk or async reset, register sum of partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_partials <= {(2*size){1'b0}};
            mul_out      <= {(2*size){1'b0}};
        end else begin
            // Sum all partial products
            // Since partial_products are reg arrays, sum them in loop
            reg [2*size-1:0] sum_tmp;
            sum_tmp = {(2*size){1'b0}};
            for (i = 0; i < size; i = i + 1) begin
                sum_tmp = sum_tmp + partial_products[i];
            end
            sum_partials <= sum_tmp;

            // Update output product with sum of partials
            mul_out <= sum_tmp;
        end
    end

endmodule