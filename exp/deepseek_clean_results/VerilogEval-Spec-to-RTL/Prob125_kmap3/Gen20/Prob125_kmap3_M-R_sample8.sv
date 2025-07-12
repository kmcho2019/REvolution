module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire not_a = ~a;
    wire not_b = ~b;
    wire not_a_and_not_b = not_a & not_b;
    wire not_a_and_not_b_and_c = not_a_and_not_b & c;
    
    assign out = a | not_a_and_not_b_and_c;
endmodule