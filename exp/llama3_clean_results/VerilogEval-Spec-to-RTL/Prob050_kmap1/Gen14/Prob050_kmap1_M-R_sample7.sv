module TopModule(
    input a,
    input b,
    input c,
    output out
);
    
    // Directly implement the OR operation for simplicity and efficiency.
    // This is based on the Karnaugh map analysis where out is 1 if any of a, b, or c is 1.
    assign out = (a == 1) || (b == 1) || (c == 1);

endmodule