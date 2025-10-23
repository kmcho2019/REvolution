module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output wire out
);
    wire a_selected, b_selected;
    
    // Select input paths based on sel
    assign a_selected = a & ~sel;
    assign b_selected = b & sel;
    
    // Combine selected paths
    assign out = a_selected | b_selected;
endmodule