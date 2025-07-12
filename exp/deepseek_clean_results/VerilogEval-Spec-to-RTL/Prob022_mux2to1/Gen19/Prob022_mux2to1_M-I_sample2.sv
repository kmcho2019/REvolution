module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_bar;
    wire and_a, and_b;
    
    assign sel_bar = ~sel;
    assign and_a = a & sel_bar;
    assign and_b = b & sel;
    assign out = and_a | and_b;
endmodule