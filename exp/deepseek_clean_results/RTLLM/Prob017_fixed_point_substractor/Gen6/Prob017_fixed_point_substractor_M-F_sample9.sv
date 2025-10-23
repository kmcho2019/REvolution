module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits (must be < N)
    parameter N = 32    // Total number of bits (must be > Q)
) (
    input wire signed [N-1:0] a,  // First fixed-point operand (Q.N format)
    input wire signed [N-1:0] b,  // Second fixed-point operand (Q.N format)
    output reg signed [N-1:0] c   // Fixed-point result (Q.N format)
);

    // Internal signed subtraction
    wire signed [N-1:0] raw_result = a - b;

    always @(*) begin
        // Check if magnitude is zero (all bits except sign are 0)
        if (raw_result[N-2:0] == {(N-1){1'b0}}) begin
            c = {1'b0, {(N-1){1'b0}};  // Force positive zero
        end else begin
            c = raw_result;  // Normal result
        end
    end

endmodule