module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Sign detection stage
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Core computation stage
always @(*) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        c = a - b;
    end else begin
        // Different signs, compare absolute values
        if (a < b) begin
            // |a| < |b|
            c = b - a;
        end else begin
            // |a| >= |b|
            c = a - b;
        end
    end
end

endmodule