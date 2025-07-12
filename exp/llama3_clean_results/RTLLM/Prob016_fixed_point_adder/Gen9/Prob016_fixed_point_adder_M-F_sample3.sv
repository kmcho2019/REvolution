module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] res;

    always @(*) begin
        if (a[N-1] == b[N-1]) begin
            // Same signs, perform addition
            res = a + b;
        end else begin
            // Different signs, perform subtraction
            if (a[N-1] == 1'b1) begin
                // a is negative, b is positive
                res = (~a + 1) - b;
            end else begin
                // a is positive, b is negative
                res = a - (~b + 1);
            end
        end

        // Check for overflow
        if (res >= (1 << (N-1))) begin
            // Overflow, set result to maximum value
            c = (1 << (N-1)) - 1;
        end else if (res < -(1 << (N-1))) begin
            // Underflow, set result to minimum value
            c = -(1 << (N-1));
        end else begin
            // No overflow or underflow, set result to res
            c = res;
        end
    end

endmodule