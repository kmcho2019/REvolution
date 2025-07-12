module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

generate
    for (genvar i = 0; i < WIDTH; i++) begin : bit_reverse
        assign out[i] = in[WIDTH-1 - i];
    end
endgenerate

endmodule