module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

always_comb begin
    // The current implementation is straightforward and efficient.
    // For potential improvements, synthesis directives or constraints could be applied.
    z = A == B;
end

endmodule