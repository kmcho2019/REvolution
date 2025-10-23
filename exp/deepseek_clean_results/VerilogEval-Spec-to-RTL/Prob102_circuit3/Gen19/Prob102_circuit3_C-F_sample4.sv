module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Intermediate signals for clarity
    wire a_and_d;
    wire final_or;

    // Optimized logic: q = b | (a & d)
    assign a_and_d = a & d;
    assign q = b | a_and_d;

endmodule