module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire not_b;
    wire and_term;
    
    assign not_b = ~b;
    assign and_term = not_b & c;
    assign out = a | and_term;
endmodule