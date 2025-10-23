module TopModule (
    input [7:0] in,
    output even_parity
);
    // Calculate even parity as XOR of all input bits
    assign even_parity = ^in;
endmodule