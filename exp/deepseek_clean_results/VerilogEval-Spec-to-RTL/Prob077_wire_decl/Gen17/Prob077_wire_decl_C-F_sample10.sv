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
    wire ab_and, cd_and;  // Clear naming showing which inputs are combined
    
    // First layer: AND operations
    AND2 and_ab (.in1(a), .in2(b), .out(ab_and));
    AND2 and_cd (.in1(c), .in2(d), .out(cd_and));
    
    // Second layer: OR operation and inversion
    assign out = ab_and | cd_and;
    assign out_n = ~out;
endmodule