module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire not_sel;
    wire a_and_not_sel;
    wire b_and_sel;
    
    assign not_sel = ~sel;
    assign a_and_not_sel = a & not_sel;
    assign b_and_sel = b & sel;
    assign out = a_and_not_sel | b_and_sel;
endmodule