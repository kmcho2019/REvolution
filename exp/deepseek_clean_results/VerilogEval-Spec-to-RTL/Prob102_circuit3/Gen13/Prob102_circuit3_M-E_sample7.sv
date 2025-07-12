module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire sel = a | b;
    wire or_cd = c | d;
    
    assign q = sel ? or_cd : 1'b0;

endmodule