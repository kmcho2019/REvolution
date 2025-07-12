module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(a, b) begin
    // Check if the MSBs of 'a' and 'b' are the same (both positive or both negative)
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = a + b;
        
        // If the result overflows (MSB is different from the MSBs of 'a' and 'b'), adjust it
        if (res[N-1] != a[N-1]) begin
            // Handle overflow by saturating the result
            if (a[N-1] == 0) begin
                res = {1'b0, {N-1{1'b1}}};  // Maximum positive value
            end else begin
                res = {1'b1, {N-1{1'b0}}};  // Minimum negative value (two's complement)
            end
        end
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 0) begin
            // 'a' is positive, 'b' is negative
            if (a >= ~b + 1) begin
                // 'a' is greater than 'b' (considering two's complement for 'b')
                res = a + ~b + 1;
            end else begin
                // 'b' is greater than 'a'
                res = ~a + b + 1;
                // Make the result negative (two's complement)
                res = ~res + 1;
            end
        end else begin
            // 'a' is negative, 'b' is positive
            if (~a + 1 >= b) begin
                // 'a' is greater than 'b' (considering two's complement for 'a')
                res = ~a + b + 1;
                // Make the result negative (two's complement)
                res = ~res + 1;
            end else begin
                // 'b' is greater than 'a'
                res = a + ~b + 1;
            end
        end
    end
end

assign c = res;

endmodule