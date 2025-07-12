module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_n;
    wire a_path, b_path;
    
    assign sel_n = ~sel;
    assign a_path = a & sel_n;
    assign b_path = b & sel;
    assign out = a_path | b_path;
endmodule