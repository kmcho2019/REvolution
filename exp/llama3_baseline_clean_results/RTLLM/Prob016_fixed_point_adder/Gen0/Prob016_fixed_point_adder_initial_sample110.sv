module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin // MSBs are the same
        res = a + b; // Absolute value addition
    end else begin // MSBs are different
        if (a[N-1] == 1) begin // a is negative
            if (b[N-1] == 0) begin // b is positive
                if (a < b) begin
                    res = b - a; // b - a, and result is positive
                    res[N-1] = 0; // Ensure MSB is 0 for positive result
                end else begin
                    res = a - b; // a - b, and result could be negative
                end
            end
        end else begin // a is positive
            if (b[N-1] == 1) begin // b is negative
                if (a < b) begin
                    res = b - a; // b - a, and result could be negative
                end else begin
                    res = a - b; // a - b, and result is positive
                    res[N-1] = 0; // Ensure MSB is 0 for positive result
                end
            end
        end
    end
end

assign c = res;

endmodule