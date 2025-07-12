module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Absolute value addition
        res = a + b;
        if (a[N-1] == 1'b1) begin  // Set MSB of result to match MSBs of a and b (sign bit remains consistent)
            res = {~(res[N-1]), res[N-2:0]} + 1;
        end
    end else begin  // Absolute value subtraction
        if (a[N-1] == 1'b0) begin  // a is positive, b is negative
            if (a > (~b + 1)) begin  // a is greater than b
                res = a - (~b + 1);  // a - b
            end else begin
                res = (~b + 1) - a;  // b - a
                if (res == 0) begin
                    res = 0;  // result is zero
                end else begin
                    res = {~(res[N-1]), res[N-2:0]} + 1;  // set MSB of result to 1 (negative)
                end
            end
        end else begin  // a is negative, b is positive
            if (b > (~a + 1)) begin  // b is greater than a
                res = b - (~a + 1);  // b - a
            end else begin
                res = (~a + 1) - b;  // a - b
                if (res == 0) begin
                    res = 0;  // result is zero
                end else begin
                    res = {~(res[N-1]), res[N-2:0]} + 1;  // set MSB of result to 1 (negative)
                end
            end
        end
    end
    // Overflow handling: observe MSB to ensure result fits within N-bit range
    if (res[N-1] == 1'b1 && a[N-1] == 1'b0 && b[N-1] == 1'b0) begin
        res = {1'b1, {N-1{1'b1}}};  // result is maximum negative value (all ones)
    end else if (res[N-1] == 1'b0 && a[N-1] == 1'b1 && b[N-1] == 1'b1) begin
        res = {1'b0, {N-1{1'b1}}};  // result is maximum positive value (all ones)
    end
    c = res;  // assign result to output port
end

endmodule