module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

reg signed [N-1:0] res;

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Same signs
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 1) begin  // a is negative
            if (b[N-1] == 0) begin  // b is positive
                if (a < b) begin  // |b| > |a|
                    res = b - a;
                end else begin  // |a| >= |b|
                    res = a - b;
                end
            end else begin  // Both are negative, but this case is handled by swapping a and b in the comparison
                if (a < b) begin
                    res = b - a;
                end else begin
                    res = a - b;
                end
            end
        end else begin  // a is positive
            if (b[N-1] == 1) begin  // b is negative
                if (a < b) begin  // |b| > |a|
                    res = b - a;
                end else begin  // |a| >= |b|
                    res = a - b;
                end
            end else begin  // Both are positive, but this case is handled above
                // Do nothing, handled by same sign condition
            end
        end
    end

    // Handle overflow
    if (res >= (1 << (N-1))) begin
        c = {1, {N-1{1'b1}}};  // Saturate at max positive value
    end else if (res < -(1 << (N-1))) begin
        c = {1, {N-1{1'b0}}};  // Saturate at max negative value
    end else begin
        c = res;
    end
end

endmodule