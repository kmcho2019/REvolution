module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire a_or_b;
    wire not_a_or_b;
    wire and_term;
    
    assign a_or_b = a | b;
    assign not_a_or_b = ~a_or_b;
    assign and_term = not_a_or_b & c;
    assign out = a | and_term;
endmodule