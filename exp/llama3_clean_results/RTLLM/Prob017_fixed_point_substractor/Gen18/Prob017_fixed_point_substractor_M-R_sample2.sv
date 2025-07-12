module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Internal wires for sign and magnitude of inputs and result
wire [N-2:0] a_mag = (a[N-1] == 1'b0) ? a[N-2:0] : {~a[N-2:0] + 1'b1};
wire [N-2:0] b_mag = (b[N-1] == 1'b0) ? b[N-2:0] : {~b[N-2:0] + 1'b1};
wire        a_sign = a[N-1];
wire        b_sign = b[N-1];

// Perform subtraction based on signs
reg signed [N-1:0] res;

always @(a, b) begin
    if (a_sign == b_sign) begin
        // Same sign, perform direct subtraction
        res = a - b;
    end else begin
        // Different signs, perform addition of absolute values
        if (a_sign == 1'b0) begin
            // a is positive, b is negative
            res = a + (~b + 1'b1);
        end else begin
            // a is negative, b is positive
            res = (~a + 1'b1) + b;
        end
    end
end

// Assign result to output, handling zero case implicitly
assign c = res;

endmodule