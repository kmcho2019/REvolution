module TopModule (
    input [7:0] in,
    output parity
);
    wire parity = ^in;
endmodule