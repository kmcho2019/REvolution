module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits (precision)
    parameter N = 32   // Total number of bits, including integer and fractional parts
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Check if the most significant bits (MSBs) of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // Absolute Value Addition
        res = a + b;
        
        // Ensure the MSB of the result is set to match the MSBs of a and b
        if (a[N-1] == 1'b1) begin
            // Handle overflow
            if (res[N-1] == 1'b0) begin
                res = {1'b1, {N-1{1'b1}}};
            end
        end
    end else begin
        // Absolute Value Subtraction
        if (a > b) begin
            // a is greater than b
            res = a - b;
        end else begin
            // b is greater than a
            res = b - a;
        end
        
        // Set the MSB of the result according to whether the result is zero or negative
        if (res == {N{1'b0}}) begin
            res = {N{1'b0}};
        end else if (res[N-1] == 1'b1) begin
            res = {1'b1, {N-1{1'b1}}};
        end
    end
end

assign c = res;

endmodule