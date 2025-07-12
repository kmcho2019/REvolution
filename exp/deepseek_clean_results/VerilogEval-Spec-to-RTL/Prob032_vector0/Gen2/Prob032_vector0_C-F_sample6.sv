module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Direct vector output (clear and explicit)
    assign outv = vec;
    
    // Compact individual bit assignments
    assign {o2, o1, o0} = vec;

endmodule