module TopModule(
    input  logic in1,
    input  logic in2,
    output logic out
);
// Direct implementation of the AND gate with one inverted input using assign
assign out = in1 & ~in2;
endmodule