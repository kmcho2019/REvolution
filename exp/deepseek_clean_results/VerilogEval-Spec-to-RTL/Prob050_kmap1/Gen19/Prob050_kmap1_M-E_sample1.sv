module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire not_a, not_b, not_c;
    
    assign not_a = ~a;
    assign not_b = ~b;
    assign not_c = ~c;
    
    assign out = ~(not_a & not_b & not_c);
endmodule