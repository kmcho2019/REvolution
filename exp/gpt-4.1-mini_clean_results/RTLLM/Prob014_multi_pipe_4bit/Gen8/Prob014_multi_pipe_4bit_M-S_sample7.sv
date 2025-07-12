module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    localparam ext_size = size * 2; // extended width = 8 for size=4

    // Stage 1 registers: zero-extend mul_a and register mul_b
    reg [ext_size-1:0] reg_mul_a;
    reg [size-1:0]     reg_mul_b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_mul_a <= {ext_size{1'b0}};
            reg_mul_b <= {size{1'b0}};
        end else begin
            reg_mul_a <= {{size{1'b0}}, mul_a}; // zero-extend mul_a at MSB
            reg_mul_b <= mul_b;
        end
    end

    // Generate and sum partial products combinationally
    wire [ext_size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = reg_mul_b[i] ? (reg_mul_a << i) : {ext_size{1'b0}};
        end
    endgenerate

    wire [ext_size-1:0] sum_partial_products =
        partial_products[0] +
        partial_products[1] +
        partial_products[2] +
        partial_products[3];

    // Stage 2 register: store final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= sum_partial_products;
    end

endmodule