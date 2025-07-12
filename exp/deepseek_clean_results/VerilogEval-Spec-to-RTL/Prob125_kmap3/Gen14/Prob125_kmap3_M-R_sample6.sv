module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire not_b;
    wire c_and_not_b;
    
    assign not_b = ~b;
    assign c_and_not_b = c & not_b;
    assign out = a | c_and_not_b;
endmodule