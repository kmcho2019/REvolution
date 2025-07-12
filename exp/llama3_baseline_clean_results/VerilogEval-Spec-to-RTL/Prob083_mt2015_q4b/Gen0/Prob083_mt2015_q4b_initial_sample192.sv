module TopModule (
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // Using XOR and inverting it to get the XNOR operation

endmodule