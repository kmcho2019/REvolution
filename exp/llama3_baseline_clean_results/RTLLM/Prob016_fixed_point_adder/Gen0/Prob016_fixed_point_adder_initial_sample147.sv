module fixed_point_adder #(
    parameter Q = 4,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Determine if the MSBs of a and b are the same (both positive or both negative)
wire same_sign = (a[N-1] == b[N-1]);

// Perform absolute value addition
wire [N-1:0] abs_add = a + b;

// Perform absolute value subtraction
wire [N-1:0] abs_sub_a_b = a - b;
wire [N-1:0] abs_sub_b_a = b - a;

// Determine the larger absolute value and set the result accordingly
always @(*) begin
    if (same_sign) begin
        // MSBs are the same, perform addition
        res = abs_add;
    end else begin
        // MSBs are different, perform subtraction
        if (a[N-1] == 1'b0) begin
            // a is positive, b is negative
            if (a >= b) begin
                // a is larger, result is a - b
                res = abs_sub_a_b;
            end else begin
                // b is larger, result is b - a
                res = abs_sub_b_a;
            end
        end else begin
            // a is negative, b is positive
            if (a <= b) begin
                // b is larger, result is b - a
                res = abs_sub_b_a;
            end else begin
                // a is larger, result is a - b
                res = abs_sub_a_b;
            end
        end
    end
end

// Assign the result to the output port
assign c = res;

endmodule