module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Direct vector assignment
    assign outv = vec;
    
    // Individual bit assignments
    assign {o2, o1, o0} = vec;

endmodule