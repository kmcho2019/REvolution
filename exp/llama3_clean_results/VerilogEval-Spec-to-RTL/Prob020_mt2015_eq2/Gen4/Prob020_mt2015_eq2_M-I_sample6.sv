module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);

always @(*) begin
    // Direct comparison as in the original optimized solution
    z = (A[1] == B[1]) & (A[0] == B[0]);
end

endmodule