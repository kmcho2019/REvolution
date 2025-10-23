module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same signs, perform addition
        res = a + b;
    end else begin // Different signs, perform subtraction
        if (a[N-1] == 0) begin // a is positive, b is negative
            res = a - (~b + 1); // Two's complement for b
        end else begin // a is negative, b is positive
            res = (~a + 1) - b; // Two's complement for a
        end
    end
end

// Assign output c based on res
assign c = (res[N-1] == 1 && res == {1'b1, {N-1{1'b0}}}) ? {N{1'b0}} : res;

endmodule