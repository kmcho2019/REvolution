// Parameterized module to reverse the bit ordering of an input vector
module TopModule #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] in,  // Input vector of parameterized width
    output [WIDTH-1:0] out // Output vector of parameterized width
);

    // Directly reverse the bit ordering using parameterization
    assign out = {in[WIDTH-1], in[WIDTH-2], in[WIDTH-3], in[WIDTH-4], in[WIDTH-5], in[WIDTH-6], in[WIDTH-7], in[WIDTH-8]};

    // Alternatively, for better scalability, consider using a generate loop
    // genvar i;
    // generate
    //     for (i = 0; i < WIDTH; i++) begin
    //         assign out[i] = in[WIDTH-1-i];
    //     end
    // endgenerate

endmodule