module TopModule (
    input [7:0] in,
    output parity
);
    assign parity = ^in;  // This remains the optimal implementation
endmodule