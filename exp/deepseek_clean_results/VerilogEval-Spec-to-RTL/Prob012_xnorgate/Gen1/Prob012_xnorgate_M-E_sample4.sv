module TopModule(
    input a,
    input b,
    output out
);
    wire b_not;
    
    assign b_not = ~b;
    assign out = a ? b : b_not;
endmodule