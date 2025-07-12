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
    // Determine the signs of the operands
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = a + b;
        // Ensure the MSB of the result matches the MSBs of the operands
        if (a[N-1] == 1'b1) begin
            // If the result overflows, set it to the maximum negative value
            if (res[N-1] == 1'b0) begin
                res = {N{1'b1}};
            end
        end
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 1'b0) begin
            // a is positive, b is negative
            if (a >= {~b[N-1], b[N-2:0]} + 1) begin
                // a is larger, result is a - b
                res = a + {~b[N-1], b[N-2:0]} + 1;
            end else begin
                // b is larger, result is b - a
                res = {~b[N-1], b[N-2:0]} + 1 + (~a + 1);
                // Ensure the MSB of the result is set correctly
                if (res[N-1] == 1'b0) begin
                    res = {N{1'b0}};
                end
            end
        end else begin
            // a is negative, b is positive
            if ({~a[N-1], a[N-2:0]} + 1 >= b) begin
                // a is larger, result is a - b
                res = {~a[N-1], a[N-2:0]} + 1 + (~b + 1);
                // Ensure the MSB of the result is set correctly
                if (res[N-1] == 1'b0) begin
                    res = {N{1'b0}};
                end
            end else begin
                // b is larger, result is b - a
                res = b + {~a[N-1], a[N-2:0]} + 1;
            end
        end
    end
    
    // Assign the result to the output port
    c = res;
end

endmodule