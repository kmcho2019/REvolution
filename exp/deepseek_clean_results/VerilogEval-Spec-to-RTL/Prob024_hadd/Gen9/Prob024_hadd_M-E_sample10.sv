module TopModule (
    input a,
    input b,
    output sum,
    output cout
);
    
    wire a_n = ~a;
    wire b_n = ~b;
    
    // Sum calculation: When b=0, pass a; when b=1, pass ~a
    assign sum = b ? a_n : a;
    
    // Carry calculation: Only 1 when both inputs are 1 (NOR of inverted inputs)
    assign cout = ~(a_n | b_n);

endmodule