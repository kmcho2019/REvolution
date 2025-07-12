module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire not_a = ~a;
    wire not_b = ~b;
    wire c_term = not_a & not_b & c;
    
    assign out = a | c_term;
endmodule