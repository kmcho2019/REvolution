module fixed_point_subtractor
#(parameter Q = 8,  // Number of fractional bits
  parameter N = 16) // Total number of bits
(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // Internal N-bit register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
    end else begin // Different signs
        if (a[N-1] == 0) begin // a is positive, b is negative
            if (a >= (-b)) begin // a is greater than or equal to the absolute value of b
                res = a + ~b + 1; // Two's complement of b
            end else begin
                res = (~a + 1) + b; // Two's complement of a and add to b
                res = ~res + 1; // Two's complement of the result
            end
        end else begin // a is negative, b is positive
            if ((~a + 1) >= b) begin // Absolute value of a is greater than or equal to b
                res = (~a + 1) + ~b + 1; // Two's complements of a and b
            end else begin
                res = a + (~b + 1); // Two's complement of b
            end
        end
    end
    
    if (res == 0) begin // Handling zero result
        c = 0;
    end else begin
        c = res;
    end
end

endmodule