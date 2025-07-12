module TopModule (
    input  a,
    input  b,
    output q
);
    // Gate-level instantiation of an AND gate primitive
    and and_inst (q, a, b);
endmodule