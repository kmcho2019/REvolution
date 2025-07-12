module AND2 (
    input in1,
    input in2,
    output out
);
    assign out = in1 & in2;
endmodule

module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    wire and1_out, and2_out;
    
    // First layer: AND gates
    AND2 and1 (.in1(a), .in2(b), .out(and1_out));
    AND2 and2 (.in1(c), .in2(d), .out(and2_out));
    
    // Second layer: OR operation and inversion
    assign out = and1_out | and2_out;
    assign out_n = ~out;
endmodule