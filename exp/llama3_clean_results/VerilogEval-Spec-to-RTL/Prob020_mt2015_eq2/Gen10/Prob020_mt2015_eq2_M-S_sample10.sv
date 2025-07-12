module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

always_comb begin
    z = (A == B);
end

endmodule