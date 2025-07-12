module TopModule (
    input a,
    input b,
    output out
);
    // XNOR implementation using 4:1 multiplexer
    // Select lines are a and b
    // Data inputs are wired according to XNOR truth table:
    // 00 -> 1, 01 -> 0, 10 -> 0, 11 -> 1
    assign out = (a & b) ? 1'b1 :  // When both inputs are 1
                 (~a & ~b) ? 1'b1 : // When both inputs are 0
                 1'b0;              // All other cases (01, 10)
    
    /* Alternative explanation:
    // This is equivalent to a 4:1 mux implementation:
    // wire [3:0] mux_in = 4'b1001; // XNOR truth table
    // assign out = mux_in[{a,b}];
    // But written more clearly with ternary operators
    */
endmodule