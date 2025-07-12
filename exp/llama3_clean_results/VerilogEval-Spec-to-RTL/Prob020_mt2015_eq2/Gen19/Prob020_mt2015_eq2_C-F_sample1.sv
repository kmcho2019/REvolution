module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

always_comb begin
    // Direct comparison for simplicity and efficiency
    z = (A == B);
end

endmodule