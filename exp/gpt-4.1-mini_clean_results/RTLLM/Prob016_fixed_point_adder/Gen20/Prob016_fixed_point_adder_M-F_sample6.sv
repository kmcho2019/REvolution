module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits (precision)
    parameter integer N = 16    // Total bits (including sign bit)
)(
    input  wire signed [N-1:0] a,   // First fixed-point operand (two's complement)
    input  wire signed [N-1:0] b,   // Second fixed-point operand (two's complement)
    output reg  signed [N-1:0] c    // Result fixed-point sum (two's complement)
);

    // Internal register to store the result
    reg signed [N-1:0] res;

    // Intermediate variables for absolute values (unsigned)
    wire [N-1:0] a_abs;
    wire [N-1:0] b_abs;

    // Compute absolute values (two's complement abs)
    assign a_abs = (a[N-1] == 1'b0) ? a : (~a + 1'b1);
    assign b_abs = (b[N-1] == 1'b0) ? b : (~b + 1'b1);

    always @(*) begin
        // Same sign addition
        if (a[N-1] == b[N-1]) begin
            // Add absolute values
            // The sum can be N or N+1 bits wide, so use N+1 bits temporarily to detect overflow if needed
            reg [N:0] abs_sum;
            abs_sum = a_abs + b_abs;

            // Saturate if overflowed (if the carry-out bit  is 1)
            // But problem states internal handling by MSB fitting, so just truncate
            if (abs_sum[N] == 1'b1) begin
                // Overflow: saturate to max or min based on sign
                if (a[N-1] == 1'b0) begin
                    // Positive overflow saturate to max positive
                    res = {1'b0, {(N-1){1'b1}}};
                end else begin
                    // Negative overflow saturate to max negative (most negative number)
                    res = {1'b1, {(N-1){1'b0}}};
                end
            end else begin
                // No overflow, assign sum with sign bit = same sign as inputs
                res = {a[N-1], abs_sum[N-1:0]};
            end
        end
        // Different sign subtraction
        else begin
            // Compare absolute values
            if (a_abs == b_abs) begin
                // Result is zero with positive sign
                res = {1'b0, {(N-1){1'b0}}};
            end
            else if (a_abs > b_abs) begin
                // res = a_abs - b_abs
                reg [N-1:0] diff;
                diff = a_abs - b_abs;
                // sign is a's sign (since |a| > |b|)
                res = {a[N-1], diff[N-2:0]};
            end
            else begin
                // res = b_abs - a_abs
                reg [N-1:0] diff;
                diff = b_abs - a_abs;
                // sign is b's sign (since |b| > |a|)
                res = {b[N-1], diff[N-2:0]};
            end
        end

        // Assign output
        c = res;
    end

endmodule