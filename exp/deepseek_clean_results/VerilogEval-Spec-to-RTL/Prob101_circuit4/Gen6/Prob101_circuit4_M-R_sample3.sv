module TopModule (
    input a,       // Don't-care input
    input b,       // Primary input
    input c,       // Primary input
    input d,       // Don't-care input
    output q       // Output as wire for continuous assignment
);

    // Using continuous assignment for simple combinational logic
    assign q = b | c;

endmodule