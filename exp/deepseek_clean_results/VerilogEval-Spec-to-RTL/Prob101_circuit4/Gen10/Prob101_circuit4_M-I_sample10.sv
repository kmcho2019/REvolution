module TopModule (
    input a,       // Unused input (tied off)
    input b,       // Primary input
    input c,       // Primary input
    input d,       // Unused input (tied off)
    output q       // Output wire
);

    // Prevent unused input switching
    wire unused_a = a;
    wire unused_d = d;

    // Most efficient implementation: direct OR operation
    assign q = b | c;

endmodule