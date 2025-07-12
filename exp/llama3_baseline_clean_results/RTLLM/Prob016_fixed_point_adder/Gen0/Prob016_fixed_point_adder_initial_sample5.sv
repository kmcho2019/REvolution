module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Determine the sign of the result based on the MSBs of a and b
always @(a, b) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        if (a[N-1] == 1'b0) begin // Both positive
            res = a + b;
        end else begin // Both negative
            res = -(-a + (-b));
        end
    end else begin // Different signs
        if (a[N-1] == 1'b0) begin // a is positive, b is negative
            if (a >= -b) begin // a is greater
                res = a + (-b);
            end else begin // b is greater
                res = -(a + (-b)); // Invert the result
            end
        end else begin // a is negative, b is positive
            if (-a >= b) begin // a is greater in absolute value
                res = -(b + (-a)); // Invert the result
            end else begin // b is greater
                res = b + (-a);
            end
        end
    end

    // Handle overflow by saturating the result
    if (res[N-1]!= res[N-2]) begin // MSB and second MSB are different
        if (res[N-1] == 1'b0) begin // Positive overflow
            res = {N{1'b1}}; // Saturate to maximum positive value
        end else begin // Negative overflow
            res = {N{1'b0}}; // Saturate to minimum negative value (0 in two's complement)
        end
    end
end

assign c = res;

endmodule