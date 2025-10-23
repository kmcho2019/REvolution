module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire a_or_d;
    wire b_and_term;
    
    assign a_or_d = a | d;
    assign b_and_term = b & a_or_d;
    assign q = c | b_and_term;
endmodule