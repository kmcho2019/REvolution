module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input  logic [N-1:0] a,  // First input operand
    input  logic [N-1:0] b,  // Second input operand
    output logic [N-1:0] c   // Output result
);

logic [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Determine the signs of the input operands
    logic sign_a = a[N-1];
    logic sign_b = b[N-1];

    // Same sign subtraction
    if (sign_a == sign_b) begin
        // Directly subtract the two operands
        res = a - b;
    end else begin
        // Different sign subtraction
        if (~sign_a && sign_b) begin
            // a is negative, b is positive
            if (a[N-2:0] < b[N-2:0]) begin
                // |a| < |b|, result is positive
                res = {1'b0, b[N-2:0]} - {1'b1, a[N-2:0]};
            end else begin
                // |a| >= |b|, result is negative
                res = {1'b1, a[N-2:0]} - {1'b0, b[N-2:0]};
            end
        end else begin
            // a is positive, b is negative
            if (a[N-2:0] < b[N-2:0]) begin
                // |a| < |b|, result is negative
                res = {1'b1, b[N-2:0]} - {1'b0, a[N-2:0]};
            end else begin
                // |a| >= |b|, result is positive
                res = {1'b0, a[N-2:0]} - {1'b1, b[N-2:0]};
            end
        end
    end

    // Handle zero result case
    if (res == 0) begin
        c = {N{1'b0}};
    end else begin
        c = res;
    end
end

endmodule