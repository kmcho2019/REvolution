module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Intermediate signals
    wire not_a;
    wire not_b;
    wire and_term;
    
    // Break down the logic
    assign not_a = ~a;
    assign not_b = ~b;
    assign and_term = not_a & not_b & c;
    assign out = a | and_term;
endmodule