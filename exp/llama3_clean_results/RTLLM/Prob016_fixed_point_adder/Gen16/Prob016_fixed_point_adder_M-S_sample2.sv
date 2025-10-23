module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

always @(*) begin
    reg [N:0] temp; // Temporary variable to hold the result with an extra bit for overflow check
    reg [N-1:0] abs_a, abs_b; // Absolute values of inputs
    
    // Determine absolute values based on signs
    if (a[N-1] == b[N-1]) begin
        // Same sign, use inputs directly
        abs_a = a;
        abs_b = b;
    end else begin
        // Different signs, invert the smaller value
        if (a[N-1] == 1'b0) begin
            abs_a = a;
            abs_b = ~b + 1'b1;
        end else begin
            abs_a = ~a + 1'b1;
            abs_b = b;
        end
    end
    
    // Perform addition
    temp = abs_a + abs_b;
    
    // Handle overflow
    if (temp[N] == 1'b1) begin
        // Overflow, set MSB and clear rest
        c = {1'b1, {N-1{1'b0}}};
    end else begin
        // No overflow, assign result
        c = temp[N-1:0];
    end
    
    // Adjust precision if necessary
    if (Q < N) begin
        // Truncate fractional part to Q bits
        c = {c[N-1:Q], {Q{1'b0}}};
    end
end

endmodule