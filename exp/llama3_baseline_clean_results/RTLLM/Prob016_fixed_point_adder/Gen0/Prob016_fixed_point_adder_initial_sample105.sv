module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits (precision)
    parameter N = 32   // Total number of bits
) (
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output wire [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register to store the result

// Determine the sign of the operands
wire sign_a = a[N-1];  // Sign bit of operand a
wire sign_b = b[N-1];  // Sign bit of operand b

// Determine the absolute values of the operands
wire [N-1:0] abs_a = (sign_a) ? (~a + 1) : a;
wire [N-1:0] abs_b = (sign_b) ? (~b + 1) : b;

// Perform addition or subtraction based on the signs of the operands
always @(*) begin
    if (sign_a == sign_b) begin  // Both positive or both negative
        res = abs_a + abs_b;
        if (sign_a) begin
            c = (res[N-1]) ? {1'b1, {N-1{1'b1}}} : ({1'b1, {N-2{0'b1}}, res[N-2:0]});
        end else begin
            c = res;
        end
    end else begin  // One positive, one negative
        if (abs_a >= abs_b) begin  // a is greater than b
            res = abs_a - abs_b;
            c = res;
        end else begin  // b is greater than a
            res = abs_b - abs_a;
            if (res == 0) begin
                c = {N{1'b0}};
            end else begin
                c = {1'b1, {N-1{1'b1}}};  // Set MSB to 1 (negative)
            end
        end
    end
end

endmodule