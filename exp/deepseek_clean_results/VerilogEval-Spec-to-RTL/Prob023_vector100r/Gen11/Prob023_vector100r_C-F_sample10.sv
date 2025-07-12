module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

// Reverse the bit order of the input vector
generate
    for (genvar i = 0; i < WIDTH; i = i + 1) begin : reverse_bits
        assign out[i] = in[WIDTH-1 - i];
    end
endgenerate

endmodule