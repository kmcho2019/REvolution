module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Vector output remains the same
    assign outv = vec;
    
    // Individual bit assignments combined into one statement
    assign {o2, o1, o0} = vec;

endmodule