module TopModule (
    input a, b, c, d,  // a and d are unused
    output q            // q = b OR c
);
    // Output is high when either b or c is high
    assign q = b | c;
endmodule