module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result
reg [N-1:0] a_abs, b_abs; // Absolute values of a and b
reg [N-1:0] sum; // Sum of absolute values

always @(*) begin
    // Calculate absolute values
    a_abs = (a[N-1] == 1'b0) ? a : ~a + 1;
    b_abs = (b[N-1] == 1'b0) ? b : ~b + 1;

    // Determine the operation (addition or subtraction)
    sum = (a[N-1] == b[N-1]) ? a_abs + b_abs : (a_abs > b_abs) ? a_abs - b_abs : b_abs - a_abs;

    // Adjust sign based on the operation and input signs
    if (a[N-1] != b[N-1]) begin
        // Different signs, result sign depends on the larger absolute value
        res = (a_abs > b_abs) ? sum : ~(sum - 1);
    end else begin
        // Same signs, result sign matches input signs
        res = (a[N-1] == 1'b1) ? ~(sum - 1) : sum;
    end

    // Check for overflow
    if (res >= (1 << (N-1))) begin
        res = (1 << (N-1)) - 1;
    end else if (res < -(1 << (N-1))) begin
        res = -(1 << (N-1));
    end

    c = res; // Assign the result to the output port
end

endmodule