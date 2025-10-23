module TopModule (
    input in1,
    input in2,
    output out
);
    wire in2_not;
    
    assign in2_not = ~in2;
    assign out = in1 & in2_not;
endmodule