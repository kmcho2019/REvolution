module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input   wire [N-1:0] a, // First N-bit fixed-point input operand
    input   wire [N-1:0] b, // Second N-bit fixed-point input operand
    output  wire [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

    reg [N-1:0] res;

    always @(*) begin
        // Determine the sign of the inputs
        if (a[N-1] == b[N-1]) begin
            // Absolute value addition
            res = (a[N-1]) ? -(~a + 1) + -(~b + 1) : a + b;
        end else begin
            // Absolute value subtraction
            if (a[N-1] == 0) begin
                // a is positive, b is negative
                if (a >= -(~b + 1)) begin
                    res = a + b;
                end else begin
                    res = -(~b + 1) - a;
                    // Check for negative result and adjust MSB accordingly
                    if (res[N-1] == 1) begin
                        res = -(~res + 1);
                    end
                end
            end else begin
                // a is negative, b is positive
                if (-(~a + 1) >= b) begin
                    res = -(~a + 1) - b;
                    // Check for negative result and adjust MSB accordingly
                    if (res[N-1] == 1) begin
                        res = -(~res + 1);
                    end
                end else begin
                    res = b - -(~a + 1);
                end
            end
        end
    end

    assign c = res;

endmodule