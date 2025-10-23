module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Determine the MSBs of the input operands
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Absolute value addition
    if (sign_a == sign_b) begin
        // Add the absolute values
        res = (a[N-1] ? -a : a) + (b[N-1] ? -b : b);
        // Set the MSB of the result to match the MSBs of a and b
        if (sign_a)
            res[N-1] = 1'b1;
        else
            res[N-1] = 1'b0;
    end
    // Absolute value subtraction
    else begin
        // Compare the absolute values and perform the subtraction
        if ((a[N-1] ? -a : a) > (b[N-1] ? -b : b)) begin
            res = (a[N-1] ? -a : a) - (b[N-1] ? -b : b);
            // Set the MSB of the result to 0 (positive)
            res[N-1] = 1'b0;
        end
        else begin
            res = (b[N-1] ? -b : b) - (a[N-1] ? -a : a);
            // Set the MSB of the result according to whether the result is zero or negative
            if (res == 0)
                res[N-1] = 1'b0;
            else
                res[N-1] = 1'b1;
        end
    end

    // Ensure the result fits within the N-bit range
    if (res > {N{1'b1}} - 1) begin
        res = {N{1'b1}} - 1;
    end
    else if (res < -{N{1'b1}}) begin
        res = -{N{1'b1}};
    end
end

assign c = res;

endmodule