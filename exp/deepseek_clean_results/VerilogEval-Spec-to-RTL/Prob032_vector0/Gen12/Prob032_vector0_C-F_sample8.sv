module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Direct vector assignment
    assign outv = vec;
    
    // Concatenated bit assignments for maximum clarity and efficiency
    assign {o2, o1, o0} = vec;

endmodule