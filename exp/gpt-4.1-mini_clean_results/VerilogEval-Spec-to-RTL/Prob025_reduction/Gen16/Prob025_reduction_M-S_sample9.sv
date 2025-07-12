module TopModule (
    input  [7:0] in,
    output       parity
);
    assign parity = ^in; // even parity via reduction XOR
endmodule