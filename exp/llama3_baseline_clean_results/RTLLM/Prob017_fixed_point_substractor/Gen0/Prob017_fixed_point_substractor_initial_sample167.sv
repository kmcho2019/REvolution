module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits (integer and fractional)
)(
    input   [N-1:0] a, // First N-bit fixed-point input operand
    input   [N-1:0] b, // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register to store the result of the subtraction operation

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign subtraction
        res = a - b;
    end else begin // Different sign subtraction
        if (a[N-1] == 0 && b[N-1] == 1) begin // a is positive, b is negative
            res = a + (~b + 1); // Add absolute values and handle borrow
        end else if (a[N-1] == 1 && b[N-1] == 0) begin // a is negative, b is positive
            res = (~a + 1) + b; // Add absolute values and handle borrow
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        c = {1'b0, {N-1{1'b0}}}; // Set sign bit to 0 and all other bits to 0
    end else begin
        c = res; // Assign result to output port
    end
end

endmodule