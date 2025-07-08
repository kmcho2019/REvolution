module TopModule (
    input  [7:0] in,
    output       parity
);
    assign parity = ^in; // XOR reduction operator to compute even parity
endmodule