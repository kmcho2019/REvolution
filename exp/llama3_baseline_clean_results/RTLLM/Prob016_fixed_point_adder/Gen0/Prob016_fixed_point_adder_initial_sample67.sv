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
    if (a[N-1] == b[N-1]) begin  // If MSBs are the same, perform absolute value addition
        res = a + b;
    end else begin  // If MSBs are different, perform absolute value subtraction
        if (a[N-1] == 1) begin  // a is negative
            if (b[N-1] == 0) begin  // b is positive
                if (a > b) begin  // |a| > |b|
                    res = a - b;
                    res[N-1] = 1;  // Set MSB to 1 (negative)
                end else begin  // |a| < |b|
                    res = b - a;
                    res[N-1] = 0;  // Set MSB to 0 (positive)
                end
            end else begin  // b is negative
                res = a + b;
            end
        end else begin  // a is positive
            if (b[N-1] == 1) begin  // b is negative
                if (a > b) begin  // |a| > |b|
                    res = a - b;
                    res[N-1] = 0;  // Set MSB to 0 (positive)
                end else begin  // |a| < |b|
                    res = b - a;
                    res[N-1] = 1;  // Set MSB to 1 (negative)
                end
            end else begin  // b is positive
                res = a + b;
            end
        end
    end

    // Overflow handling
    if (res[N-1] == 1) begin  // If result is negative
        if (res[N-2:0] == {N-1{1}}) begin  // If fractional part is all ones
            res = {1, {N-1{0}}};  // Set result to minimum value
        end else begin
            res = res - 1;  // Subtract 1 to handle overflow
        end
    end else begin  // If result is positive
        if (res[N-2:0] == {N-1{0}}) begin  // If fractional part is all zeros
            res = {1, {N-1{1}}};  // Set result to maximum value
        end
    end
end

assign c = res;  // Assign result to output port

endmodule