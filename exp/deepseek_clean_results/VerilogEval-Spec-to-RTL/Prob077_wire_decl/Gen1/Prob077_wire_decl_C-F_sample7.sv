module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // First layer: AND gates with immediate assignment
    wire and1_out = a & b;
    wire and2_out = c & d;
    
    // Second layer: OR and NOT gates
    assign out = and1_out | and2_out;
    assign out_n = ~out;

endmodule