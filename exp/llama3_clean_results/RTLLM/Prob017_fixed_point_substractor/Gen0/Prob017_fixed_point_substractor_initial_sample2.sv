module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of the inputs
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Perform same sign subtraction
    if (sign_a == sign_b) begin
        // Subtract the absolute values of a and b
        res = (sign_a? -a : a) - (sign_b? -b : b);
    end
    // Perform different sign subtraction
    else begin
        // Add the absolute values of a and b
        res = (sign_a? -a : a) + (sign_b? -b : b);
    end

    // Handle zero result
    if (res == 0) begin
        res = 0;
    end
    // Assign the result to the output
    c = res;
end

endmodule