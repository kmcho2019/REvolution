module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input  [N-1:0] a, // First N-bit fixed-point input operand
    input  [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register used to store the result of the subtraction operation

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
    end else begin // Different signs
        if (a[N-1] == 0) begin // a is positive, b is negative
            if (a >= ~b + 1) begin // a is greater than or equal to the absolute value of b
                res = a + (~b + 1);
            end else begin // a is less than the absolute value of b
                res = ~(~a + b + 1);
            end
        end else begin // a is negative, b is positive
            if (~a + 1 >= b) begin // The absolute value of a is greater than or equal to b
                res = ~(~a + b + 1);
            end else begin // The absolute value of a is less than b
                res = ~a + (~b + 1);
            end
        end
    end
    
    // Handle the edge case where the result is zero
    if (res == {N{1'b0}}) begin
        res = {N{1'b0}};
    end
end

assign c = res;

endmodule