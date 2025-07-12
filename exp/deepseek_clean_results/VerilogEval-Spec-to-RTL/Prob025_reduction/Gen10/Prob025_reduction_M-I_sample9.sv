module TopModule (
    input [7:0] in,
    output parity
);
    assign parity = ^in;  // Optimal implementation - cannot be improved
endmodule