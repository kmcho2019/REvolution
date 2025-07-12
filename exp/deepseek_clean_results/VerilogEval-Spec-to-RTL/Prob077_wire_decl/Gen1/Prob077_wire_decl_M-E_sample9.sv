module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // First layer: AND gates
    wire ab_and = a & b;
    wire cd_and = c & d;

    // Second layer implemented as 2:1 MUX configured as OR
    assign out = cd_and | ab_and;  // MUX with sel=1 would give same result
    assign out_n = ~out;

endmodule