module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

// Determine the signs of the input operands
wire sign_a = a[N-1]; // Sign bit of operand a
wire sign_b = b[N-1]; // Sign bit of operand b

// Perform absolute value addition or subtraction
always @(*) begin
    if (sign_a == sign_b) begin
        // Absolute value addition
        if (sign_a) begin
            // Both negative, add absolute values and set result negative
            res = -({1'b0, a[N-2:0]} + {1'b0, b[N-2:0]});
        end else begin
            // Both positive, add absolute values and set result positive
            res = {1'b0, a[N-2:0]} + {1'b0, b[N-2:0]};
        end
    end else begin
        // Absolute value subtraction
        if ({1'b0, a[N-2:0]} > {1'b0, b[N-2:0]}) begin
            // a is greater than b, subtract b from a and set result positive
            res = {1'b0, a[N-2:0]} - {1'b0, b[N-2:0]};
        end else begin
            // b is greater than a, subtract a from b and set result according to sign
            res = {1'b0, b[N-2:0]} - {1'b0, a[N-2:0]};
        end
    end
end

// Assign the result to the output port
assign c = res;

endmodule