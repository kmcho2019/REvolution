module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output wire [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register to store the result

always @(*) begin
    // Determine the signs of the input operands
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Check if the signs are the same (both positive or both negative)
    if (sign_a == sign_b) begin
        // Absolute value addition
        res = (a[N-1] == 1'b0) ? (a + b) : (~a + 1 + ~b + 1);
        // Maintain the sign consistency
        c = (sign_a == 1'b0) ? res : (~res + 1);
    end else begin
        // Absolute value subtraction
        if ((a[N-1] == 1'b0 && ~a + 1 > ~b + 1) || (a[N-1] == 1'b1 && ~a + 1 < ~b + 1)) begin
            // a is greater than b
            res = a + (~b + 1);
            c = res;
        end else begin
            // b is greater than a
            res = b + (~a + 1);
            c = (~res + 1);
        end
    end
end

endmodule