module TopModule (
    input wire x,
    input wire y,
    output reg z
);

always @(*) begin
    // Intermediate wire for XOR of inputs
    // z is set to the inverse of xor_xy
    reg xor_xy;
    xor_xy = x ^ y;
    z = ~xor_xy;
end

endmodule