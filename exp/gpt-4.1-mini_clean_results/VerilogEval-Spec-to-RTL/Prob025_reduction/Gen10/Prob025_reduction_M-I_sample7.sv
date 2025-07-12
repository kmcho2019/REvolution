module TopModule (
    input  [7:0] in,
    output       parity
);
    assign parity = ^in; // Use continuous assignment with reduction XOR for minimal logic
endmodule