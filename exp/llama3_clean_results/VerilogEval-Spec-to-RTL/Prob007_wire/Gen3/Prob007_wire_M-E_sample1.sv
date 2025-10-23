module TopModule(
    input  in,
    output out
);
    
    // Using a buffer gate to isolate the input from the output
    buf1 u_buf1 (.A(in), .Y(out));

endmodule

// Buffer gate module
module buf1(
    input  A,
    output Y
);
    
    assign Y = A;

endmodule