module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res; // Internal register for result

// Determine the operation and perform it
always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same signs, perform addition
        res = a + b;
    end else begin // Different signs, determine larger absolute value and perform subtraction
        if (a[N-1] == 1 && b[N-1] == 0) begin // a is negative, b is positive
            if (a < b) begin
                res = b - a;
            end else begin
                res = a - b;
                res[N-1] = 1; // Set sign bit for negative result
            end
        end else begin // a is positive, b is negative
            if (a < b) begin
                res = a - b;
                res[N-1] = 1; // Set sign bit for negative result
            end else begin
                res = a - b;
            end
        end
    end
    // Handle overflow by checking MSB and adjusting if necessary
    if (res[N-1] == 1 && res[N-2] == 1) begin // Negative overflow
        res = {1'b0, {N-1{1'b1}}}; // Set to max negative value
    end else if (res[N-1] == 0 && res[N-2] == 0) begin // Positive overflow
        res = {N{1'b1}}; // Set to max positive value
    end
    c = res;
end

endmodule