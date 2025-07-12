module TopModule (
    input a,       // Don't-care input
    input b,       // Primary input
    input c,       // Primary input
    input d,       // Don't-care input
    output q      // Output depends only on b and c
);

    // Minimal combinational logic
    assign q = b | c;

endmodule