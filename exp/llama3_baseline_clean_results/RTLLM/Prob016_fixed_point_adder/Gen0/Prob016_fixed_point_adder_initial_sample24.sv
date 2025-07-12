module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the sign of the input operands
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = a + b;
        
        // Handle overflow
        if (res[N-1]!= a[N-1]) begin
            if (a[N-1] == 1'b0) begin
                res = {1'b0, {N-1{1'b1}}}; // Saturate to maximum positive value
            end else begin
                res = {1'b1, {N-1{1'b0}}}; // Saturate to maximum negative value
            end
        end
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            // a is positive, b is negative
            if (a >= ~b + 1) begin
                res = a - (~b + 1); // a - b
            end else begin
                res = ~(~a + b) + 1; // b - a
            end
        end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
            // a is negative, b is positive
            if (b >= ~a + 1) begin
                res = b - (~a + 1); // b - a
            end else begin
                res = ~(~b + a) + 1; // a - b
            end
        end
        
        // Handle overflow
        if (res[N-1]!= a[N-1] && res[N-1]!= b[N-1]) begin
            if (res[N-1] == 1'b0) begin
                res = {1'b0, {N-1{1'b1}}}; // Saturate to maximum positive value
            end else begin
                res = {1'b1, {N-1{1'b0}}}; // Saturate to maximum negative value
            end
        end
    end
    
    // Assign the result to the output
    c = res;
end

endmodule