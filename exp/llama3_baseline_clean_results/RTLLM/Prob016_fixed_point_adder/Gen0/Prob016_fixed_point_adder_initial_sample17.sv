module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Determine the sign bits of a and b
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Determine if the absolute values should be added or subtracted
wire add_abs = sign_a == sign_b;

// Perform absolute value addition or subtraction
always @(*) begin
    if (add_abs) begin
        // Absolute value addition
        res = (a[N-1] ? -a : a) + (b[N-1] ? -b : b);
        // Set the sign bit of the result
        if (sign_a)
            res = -res;
    end else begin
        // Absolute value subtraction
        if ((a[N-1] ? -a : a) >= (b[N-1] ? -b : b)) begin
            res = (a[N-1] ? -a : a) - (b[N-1] ? -b : b);
        end else begin
            res = (b[N-1] ? -b : b) - (a[N-1] ? -a : a);
        end
        // Set the sign bit of the result
        if (res < 0)
            res = -res;
    end
end

// Assign the result to the output port
assign c = res;

endmodule