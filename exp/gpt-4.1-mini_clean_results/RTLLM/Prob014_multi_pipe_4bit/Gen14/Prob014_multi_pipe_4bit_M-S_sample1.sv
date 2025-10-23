module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Sum all partial products combinationally
    wire [2*size-1:0] sum_all = 
        partial_products[0] +
        partial_products[1] +
        partial_products[2] +
        partial_products[3];

    // Stage 1 register: latch sum of partial products
    reg [2*size-1:0] stage1_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage1_sum <= {2*size{1'b0}};
        else
            stage1_sum <= sum_all;
    end

    // Stage 2 register: latch final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= stage1_sum;
    end

endmodule