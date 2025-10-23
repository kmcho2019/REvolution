module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire c_or_d = c | d;
    
    assign q = (a & b) ? c_or_d :
               (a & ~b) ? c_or_d :
               (~a & b) ? c_or_d :
               1'b0;

endmodule