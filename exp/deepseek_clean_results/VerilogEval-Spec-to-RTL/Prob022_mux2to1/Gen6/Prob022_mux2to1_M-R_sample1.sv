module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output wire out
);
    wire a_path, b_path;
    
    // AND gates for input selection
    assign a_path = a & ~sel;
    assign b_path = b & sel;
    
    // OR gate to combine paths
    assign out = a_path | b_path;
endmodule