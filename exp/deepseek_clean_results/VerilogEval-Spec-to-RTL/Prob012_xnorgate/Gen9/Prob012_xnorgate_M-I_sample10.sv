module TopModule (
    input a,
    input b,
    output out
);
    wire a_and_b, not_a_and_not_b, not_a, not_b;
    
    assign not_a = ~a;
    assign not_b = ~b;
    assign a_and_b = a & b;
    assign not_a_and_not_b = not_a & not_b;
    assign out = a_and_b | not_a_and_not_b;
endmodule