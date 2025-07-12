module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Direct connection for the vector output
    assign outv = vec;

    // Direct bit assignments without intermediate wire
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule