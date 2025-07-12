module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input  logic [N-1:0] a, // First N-bit fixed-point input operand
    input  logic [N-1:0] b, // Second N-bit fixed-point input operand
    output logic [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

    logic [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

    // Determine the sign of the operands
    logic sign_a, sign_b;
    assign sign_a = a[N-1];
    assign sign_b = b[N-1];

    // Determine the absolute values of the operands
    logic [N-1:0] abs_a, abs_b;
    assign abs_a = (sign_a)? (~a + 1) : a;
    assign abs_b = (sign_b)? (~b + 1) : b;

    // Perform absolute value addition or subtraction
    always_comb begin
        if (sign_a == sign_b) begin // Both positive or both negative
            res = a + b;
        end else begin // One positive, one negative
            if (abs_a > abs_b) begin // a is greater than b
                res = a - b;
            end else begin // b is greater than a
                res = b - a;
            end
        end
    end

    // Assign the result to the output port
    assign c = res;

endmodule