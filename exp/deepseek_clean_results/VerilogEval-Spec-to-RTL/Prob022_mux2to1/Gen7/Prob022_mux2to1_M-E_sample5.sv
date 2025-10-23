module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_bar;
    wire a_path, b_path;
    
    assign sel_bar = ~sel;
    assign a_path = a & sel_bar;
    assign b_path = b & sel;
    assign out = a_path | b_path;
endmodule