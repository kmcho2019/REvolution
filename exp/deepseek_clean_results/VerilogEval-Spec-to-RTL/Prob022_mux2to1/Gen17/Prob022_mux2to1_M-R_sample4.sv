module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire a_selected, b_selected;
    
    assign a_selected = a & ~sel;
    assign b_selected = b & sel;
    assign out = a_selected | b_selected;
endmodule