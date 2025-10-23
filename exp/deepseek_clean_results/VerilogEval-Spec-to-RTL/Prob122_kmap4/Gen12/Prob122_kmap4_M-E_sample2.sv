module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // First level mux selects between two patterns based on 'a'
    wire pattern0 = (c ^ d) ^ 1'b0;  // Pattern for a=0
    wire pattern1 = (c ^ d) ^ 1'b1;  // Pattern for a=1

    // Second level mux selects final output based on 'b'
    assign out = b ? pattern1 : pattern0;

endmodule