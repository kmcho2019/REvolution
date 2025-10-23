module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   logic [N-1:0] a,
    input   logic [N-1:0] b,
    output  logic [N-1:0] c
);

logic [N-1:0] res;  // Internal register for the result

// Determine the sign of the inputs
logic sign_a;
logic sign_b;

assign sign_a = a[N-1];
assign sign_b = b[N-1];

// Perform addition or subtraction based on the signs
always_comb begin
    if (sign_a == sign_b) begin
        // Add absolute values if signs are the same
        res = (a[N-1]? -a : a) + (b[N-1]? -b : b);
        // Maintain the sign consistency
        if (res[N-1]!= sign_a) begin
            // Handle potential overflow
            if (res[N-1] == 1'b1) begin
                // If result is negative, invert and add 1 to handle two's complement
                res = ~(res) + 1;
            end else begin
                // If result is positive and does not match the expected sign, adjust accordingly
                if (sign_a) begin
                    res = ~(res) + 1;  // Convert to negative if necessary
                end
            end
        end
    end else begin
        // Perform subtraction if signs are different
        if ((a[N-1]? -a : a) >= (b[N-1]? -b : b)) begin
            // a is larger, subtract b from a
            res = (a[N-1]? -a : a) - (b[N-1]? -b : b);
            // Set the sign of the result to positive (since a is larger)
            if (res[N-1] == 1'b1) begin
                // Handle potential overflow or incorrect sign
                res = ~(res) + 1;  // Convert to positive if necessary
            end
        end else begin
            // b is larger, subtract a from b
            res = (b[N-1]? -b : b) - (a[N-1]? -a : a);
            // Set the sign of the result based on whether it's zero or negative
            if (res == 0) begin
                // Result is zero, no sign needed
                res = 0;
            end else if (res[N-1] == 1'b0) begin
                // Result is positive but should be negative, adjust accordingly
                res = ~(res) + 1;  // Convert to negative
            end
        end
    end
end

assign c = res;

endmodule