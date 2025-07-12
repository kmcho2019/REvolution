module TopModule (
    input  [7:0] in,
    output       parity
);
    assign parity = ^in; // reduction XOR computes even parity
endmodule