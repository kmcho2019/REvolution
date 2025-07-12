module TopModule #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output parity
);
    assign parity = ^in;  // XOR reduction for even parity
endmodule