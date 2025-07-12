module TopModule (
    input a,       // Unused input
    input b,       // Primary input
    input c,       // Primary input
    input d,       // Unused input
    output q       // Combinational output
);

    assign q = b | c;

endmodule