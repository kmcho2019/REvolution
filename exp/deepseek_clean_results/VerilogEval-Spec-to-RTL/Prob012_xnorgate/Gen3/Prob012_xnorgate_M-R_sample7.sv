module TopModule (
    input a,
    input b,
    output out
);
    wire a_not, b_not;
    wire and_ab, and_notab;
    
    assign a_not = ~a;
    assign b_not = ~b;
    assign and_ab = a & b;
    assign and_notab = a_not & b_not;
    assign out = and_ab | and_notab;
endmodule