module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

always_comb begin
    logic [1:0] xor_result;
    xor_result = A ^ B;
    z = (xor_result == 2'b00) ? 1'b1 : 1'b0;
end

endmodule