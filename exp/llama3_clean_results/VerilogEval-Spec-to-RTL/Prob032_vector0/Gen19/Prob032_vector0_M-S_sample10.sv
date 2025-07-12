module TopModule(
    input  [2:0] vec,
    output [2:0] outv = vec,
    output o2 = vec[2],
    output o1 = vec[1],
    output o0 = vec[0]
);

endmodule