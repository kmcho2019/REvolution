module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  wire [N-1:0] a,  // First input operand
    input  wire [N-1:0] b,  // Second input operand
    output wire [N-1:0] c   // Output result
);

reg [N-1:0] res;  // Internal register for result

always @(*) begin
    // Check if 'a' and 'b' have the same sign
    if ((a[N-1] == 1 && b[N-1] == 1) || (a[N-1] == 0 && b[N-1] == 0)) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a[N-1] == 1 && b[N-1] == 0) begin
            // 'a' is negative, 'b' is positive
            if (a[N-1:0] < ~b[N-1:0] + 1) begin
                // Result is positive
                res = ~a[N-1:0] + 1 + b[N-1:0];
            end else begin
                // Result is negative
                res = a[N-1:0] - b[N-1:0];
            end
        end else begin
            // 'a' is positive, 'b' is negative
            if (a[N-1:0] > ~b[N-1:0] + 1) begin
                // Result is positive
                res = a[N-1:0] - (~b[N-1:0] + 1);
            end else begin
                // Result is negative
                res = (~a[N-1:0] + 1) + b[N-1:0];
            end
        end
    end

    // Handle zero result case
    if (res == 0) begin
        res[N-1] = 0;  // Explicitly set sign bit to 0
    end
end

assign c = res;  // Assign result to output

endmodule