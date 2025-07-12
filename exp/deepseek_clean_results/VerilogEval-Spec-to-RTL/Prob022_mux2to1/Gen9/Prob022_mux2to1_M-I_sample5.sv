module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_n;
    wire a_sel, b_sel;
    
    assign sel_n = ~sel;
    assign a_sel = a & sel_n;
    assign b_sel = b & sel;
    assign out = a_sel | b_sel;
endmodule