module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire not_b, not_c;
    
    assign not_b = ~b;
    assign not_c = ~c;
    assign q = ~(not_b & not_c);

endmodule