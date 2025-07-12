module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

// Directly connect the vector output
assign outv = vec;

// Concatenate individual bit outputs in one assignment
assign {o2, o1, o0} = vec;

endmodule