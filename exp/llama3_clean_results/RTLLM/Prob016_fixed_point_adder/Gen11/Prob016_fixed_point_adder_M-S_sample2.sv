module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Determine signs of operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform addition or subtraction based on signs
always @(*) begin
    if (sign_a == sign_b) begin
        // Same signs, add
        res = a + b;
    end else begin
        // Different signs, perform subtraction
        if (a[N-1] == 1'b0) begin
            // a is positive, b is negative
            res = a + (~b + 1'b1);
        end else begin
            // a is negative, b is positive
            res = (~a + 1'b1) + b;
        end
    end
end

assign c = res;

endmodule