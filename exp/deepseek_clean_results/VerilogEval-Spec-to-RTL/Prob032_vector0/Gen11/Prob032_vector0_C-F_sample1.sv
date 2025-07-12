module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Direct vector assignment - clean and efficient
    assign outv = vec;
    
    // Explicit bit assignments - clear and maintainable
    assign {o2, o1, o0} = vec;

endmodule