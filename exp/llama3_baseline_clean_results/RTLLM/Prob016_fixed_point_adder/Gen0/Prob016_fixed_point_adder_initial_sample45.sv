module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits (precision)
    parameter N = 32   // Total number of bits, including integer and fractional parts
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Check the signs of 'a' and 'b'
    if (a[N-1] == b[N-1]) begin
        // If the signs are the same, perform addition
        res = a + b;
        if (res >= (1 << N)) begin
            // Handle overflow by setting the MSB
            res = {1'b1, {N-1{1'b0}}};
        end
    end else begin
        // If the signs are different, perform subtraction
        if (a[N-1] == 1'b0) begin
            // 'a' is positive, 'b' is negative
            if (a >= (~b + 1)) begin
                res = a - (~b + 1);
                res[N-1] = 1'b0;  // Set the sign bit to positive
            end else begin
                res = (~a + 1) - b;
                if (res == 0) begin
                    res = 0;
                end else begin
                    res[N-1] = 1'b1;  // Set the sign bit to negative
                end
            end
        end else begin
            // 'a' is negative, 'b' is positive
            if (b >= (~a + 1)) begin
                res = b - (~a + 1);
                res[N-1] = 1'b0;  // Set the sign bit to positive
            end else begin
                res = (~b + 1) - a;
                if (res == 0) begin
                    res = 0;
                end else begin
                    res[N-1] = 1'b1;  // Set the sign bit to negative
                end
            end
        end
    end
    c = res;
end

endmodule