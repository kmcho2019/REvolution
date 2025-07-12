module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_n;
    wire a_and_sel_n;
    wire b_and_sel;
    
    assign sel_n = ~sel;
    assign a_and_sel_n = a & sel_n;
    assign b_and_sel = b & sel;
    assign out = a_and_sel_n | b_and_sel;
endmodule