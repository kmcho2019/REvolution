module TopModule (
    input a,       // Unused input
    input b,       // Primary input
    input c,       // Primary input
    input d,       // Unused input
    output q       // Output as wire
);

    assign q = b | c;

endmodule