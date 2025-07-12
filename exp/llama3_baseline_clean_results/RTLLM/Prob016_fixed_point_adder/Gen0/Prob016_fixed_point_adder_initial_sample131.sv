module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16   // Total number of bits
) (
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // If the most significant bits (MSBs) of `a` and `b` are the same
        // Perform absolute value addition
        res = a + b;
        
        // Ensure the sign bit remains consistent
        if (res[N-1]!= a[N-1]) begin
            // If the result overflows, manage it according to the sign
            if (a[N-1] == 1'b0) begin
                res = {1'b0, {N-1{1'b1}}};  // Saturate to maximum positive value
            end else begin
                res = {1'b1, {N-1{1'b0}}};  // Saturate to maximum negative value
            end
        end
    end else begin
        // Perform absolute value subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
            res = a + (~b + 1'b1);  // Invert b and add 1 to get the two's complement
        end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // a is negative, b is positive
            res = b + (~a + 1'b1);  // Invert a and add 1 to get the two's complement
        end
        
        // Set the sign bit of the result according to whether the result is zero or negative
        if (res[N-1] == 1'b1) begin
            // If the result is negative, ensure it fits within the N-bit range
            if (res == {N{1'b1}}) begin
                res = {N{1'b0}};  // Saturate to zero
            end
        end
    end
    
    c = res;
end

endmodule