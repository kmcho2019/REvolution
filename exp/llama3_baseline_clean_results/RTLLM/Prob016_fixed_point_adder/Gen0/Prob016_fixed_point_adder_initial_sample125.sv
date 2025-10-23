module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register to store the result

// Determine the sign bits of a and b
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform absolute value addition or subtraction
always @(a, b) begin
    if (sign_a == sign_b) begin
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (a[N-1:Q] > b[N-1:Q]) begin
            // a is greater than b, perform a - b
            res = a - b;
        end else begin
            // b is greater than a, perform b - a
            res = b - a;
        end
    end
end

// Assign the result to the output, handling overflow
always @(res) begin
    if (res[N-1] == 1'b1 && sign_a == 1'b1) begin
        // Overflow, saturate the result
        c = {1'b1, {N-1{1'b1}}};
    end else if (res[N-1] == 1'b1 && sign_a == 1'b0) begin
        // Underflow, saturate the result
        c = {N{1'b0}};
    end else begin
        // No overflow, assign the result directly
        c = res;
    end
end

endmodule