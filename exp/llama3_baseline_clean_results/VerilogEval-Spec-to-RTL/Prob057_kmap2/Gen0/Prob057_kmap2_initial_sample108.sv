module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    assign out = (a'b' & c'd') | 
                 (a'b' & c'd)  | 
                 (a'b' & cd')  | 
                 (a'bc'd')     | 
                 (a'bc'd)      | 
                 (ab'c'd')     | 
                 (ab'cd')      | 
                 (abc'd')      | 
                 (abcd');

endmodule