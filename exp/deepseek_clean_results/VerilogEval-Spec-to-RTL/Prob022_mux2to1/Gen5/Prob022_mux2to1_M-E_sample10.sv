module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire not_sel;
    wire a_path, b_path;
    
    assign not_sel = ~sel;
    assign a_path = a & not_sel;
    assign b_path = b & sel;
    assign out = a_path | b_path;
endmodule