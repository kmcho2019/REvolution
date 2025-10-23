module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Determine signs of operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Calculate absolute values
wire [N-1:0] abs_a = sign_a? (~a + 1) : a;
wire [N-1:0] abs_b = sign_b? (~b + 1) : b;

// Perform addition or subtraction based on signs
always @(*) begin
    if (sign_a == sign_b) begin
        // Same signs, add absolute values
        res = abs_a + abs_b;
    end else begin
        // Different signs, perform subtraction
        if (abs_a >= abs_b) begin
            // a is greater, subtract b from a
            res = abs_a - abs_b;
        end else begin
            // b is greater, subtract a from b
            res = abs_b - abs_a;
        end
    end

    // Handle overflow
    if (res[N-1]!= sign_a && res!= 0) begin
        // Overflow occurred, set MSB according to the original signs
        res = {1'b1, {N-1{1'b0}}};
    end
end

assign c = res;

endmodule