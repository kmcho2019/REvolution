module TopModule(
    input  in,
    output out
);
    
    assign out = ~in;  // Using bitwise NOT operator (~)
    // Alternatively, you can also use the logical NOT operator (!) as follows:
    // assign out = !in;

endmodule