module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res;

// Determine the sign of the result
always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Both positive or both negative, add absolute values
        res = a + b;
    end else begin
        // One positive and one negative, subtract absolute values
        if (a[N-1] == 0) begin
            // a is positive, b is negative
            res = a + (~b + 1);
        end else begin
            // a is negative, b is positive
            res = (~a + 1) + b;
        end
    end

    // Assign result to output
    c = res;
end

endmodule