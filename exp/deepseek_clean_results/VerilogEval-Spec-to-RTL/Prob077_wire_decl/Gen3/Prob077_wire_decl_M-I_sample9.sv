module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Combined wire declaration and assignment
    wire and1_out = a & b;
    wire and2_out = c & d;
    
    // Output logic
    assign out = and1_out | and2_out;
    assign out_n = ~out;

endmodule