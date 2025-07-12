module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);
always @(*) begin
    z = (A == B) ? 1'b1 : 1'b0;
    // Similar to the assign statement, this can be simplified to:
    // z = A == B;
    // But we keep the ternary operator form for consistency and clarity.
end
endmodule