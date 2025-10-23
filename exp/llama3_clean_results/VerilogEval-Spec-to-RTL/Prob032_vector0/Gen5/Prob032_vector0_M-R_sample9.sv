module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Alternative approach using bitwise extraction for individual bits
assign {o2, o1, o0} = vec;

endmodule