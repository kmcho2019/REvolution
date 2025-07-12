module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

// Directly assign input vector to output vector
assign outv = vec;

// Unpack the input vector bits directly to individual outputs in one statement
assign {o2, o1, o0} = vec;

endmodule