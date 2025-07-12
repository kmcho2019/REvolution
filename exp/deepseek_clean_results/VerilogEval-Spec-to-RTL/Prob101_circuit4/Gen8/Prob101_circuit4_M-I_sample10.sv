module TopModule (
    input a,       // Unused input
    input b,       // Primary input
    input c,       // Primary input
    input d,       // Unused input
    output q       // Output wire
);

    // Most efficient implementation: direct OR operation
    assign q = b | c;

endmodule