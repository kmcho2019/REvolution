module fixed_point_adder #(
    parameter N = 32, // Total number of bits
    parameter Q = 16  // Number of fractional bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Determine the sign of the inputs
wire a_sign = a[N-1];
wire b_sign = b[N-1];

// Perform absolute value addition or subtraction
always @(*) begin
    if (a_sign == b_sign) begin // Same signs, add absolute values
        res = (a[N-1] == 1'b0)? (a + b) : (~a + 1 + ~b + 1); // Add, considering two's complement
        res[N-1] = a_sign; // Set sign of result to match inputs
    end else begin // Different signs, perform subtraction
        if ((a[N-1] == 1'b0 && b[N-1] == 1'b1 && (a > (~b + 1))) || (a[N-1] == 1'b1 && b[N-1] == 1'b0 && (~a + 1 > b))) begin
            // a is larger, subtract b from a
            res = (a_sign == 1'b0)? (a - (~b + 1)) : ((~a + 1) - b);
            res[N-1] = 1'b0; // Result is positive
        end else begin
            // b is larger, subtract a from b
            res = (b_sign == 1'b0)? (b - (~a + 1)) : ((~b + 1) - a);
            res[N-1] = b_sign; // Set sign of result to match b
        end
    end
end

// Assign result to output
assign c = res;

endmodule