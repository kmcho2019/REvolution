module TopModule (
    input [7:0] in,
    output parity
);
    assign parity = ^in;  // This is already the simplest possible implementation
endmodule