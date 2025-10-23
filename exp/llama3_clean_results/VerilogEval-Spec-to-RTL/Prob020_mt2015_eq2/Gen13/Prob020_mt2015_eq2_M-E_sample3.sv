module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

logic [1:0] xor_result;

always_comb begin
    xor_result = A ^ B;
    z = (xor_result == 2'b00)? 1'b1 : 1'b0;
end

endmodule