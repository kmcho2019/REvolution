module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Internal array for partial products
    wire [15:0] partial_products [7:0];
    integer i;

    // Generate partial products
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? (A << i) : 16'b0;
        end
    endgenerate

    // Sum partial products sequentially (ripple-add)
    // This reduces hardware from balanced tree of adders
    reg [15:0] sum [0:8];
    integer j;

    always @(*) begin
        sum[0] = 16'b0;
        for (j = 0; j < 8; j = j + 1) begin
            sum[j+1] = sum[j] + partial_products[j];
        end
    end

    assign product = sum[8];

endmodule