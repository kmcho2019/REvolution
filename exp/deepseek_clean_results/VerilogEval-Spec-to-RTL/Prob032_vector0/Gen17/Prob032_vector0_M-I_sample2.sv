module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Combined vector and bit assignments
    assign {outv, o2, o1, o0} = {vec, vec};

endmodule