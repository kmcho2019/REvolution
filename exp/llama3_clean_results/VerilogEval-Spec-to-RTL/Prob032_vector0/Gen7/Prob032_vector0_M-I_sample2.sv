module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Direct assignments are already optimal for this design.
// However, we ensure that each bit is directly assigned to minimize any potential for optimization by the synthesis tool.
assign outv = vec;
assign o2 = vec[2];
assign o1 = vec[1];
assign o0 = vec[0];

endmodule