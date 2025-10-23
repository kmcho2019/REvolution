module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

always_comb begin
    z = (A == B) ? 1'b1 : 1'b0;
end

endmodule