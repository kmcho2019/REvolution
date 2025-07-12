module TopModule(
    input  logic in1,
    input  logic in2,
    output logic out
);
// Direct implementation of the AND gate with one inverted input
always_comb begin
    out = in1 & ~in2;
end
endmodule