module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire a_and, b_and;
    
    assign a_and = a & ~sel;
    assign b_and = b & sel;
    assign out = a_and | b_and;
endmodule