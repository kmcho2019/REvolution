module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2 = vec[2],
    output o1 = vec[1],
    output o0 = vec[0]
);

    assign outv = vec;

endmodule