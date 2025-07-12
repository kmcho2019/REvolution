module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire ab = a | b;
    wire cd = c | d;
    
    assign q = cd ? ab : 1'b0;
endmodule