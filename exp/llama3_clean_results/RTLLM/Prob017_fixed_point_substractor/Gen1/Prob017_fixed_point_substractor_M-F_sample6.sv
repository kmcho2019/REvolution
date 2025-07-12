module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register to store the result of the subtraction operation

always @(a, b) begin
    // Same sign subtraction
    if ((a[N-1] == 0 && b[N-1] == 0) || (a[N-1] == 1 && b[N-1] == 1)) begin
        // Subtract b from a
        res = a - b;
    end else if (a[N-1] == 0 && b[N-1] == 1) begin
        // Add absolute values of a and b
        res = a + (~b + 1);
    end else if (a[N-1] == 1 && b[N-1] == 0) begin
        // Add absolute values of a and b
        res = (~a + 1) + b;
    end
    
    // Handle zero result
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule