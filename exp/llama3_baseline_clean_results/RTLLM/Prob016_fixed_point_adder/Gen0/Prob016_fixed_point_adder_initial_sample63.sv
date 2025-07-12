module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits, including integer and fractional parts
)(
    input  wire [N-1:0] a, // First N-bit fixed-point input operand
    input  wire [N-1:0] b, // Second N-bit fixed-point input operand
    output wire [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Determine the signs of the operands
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Absolute value addition
    if (sign_a == sign_b) begin
        // Calculate the absolute value sum
        res = (a[N-1] == 1'b0) ? (a + b) : -(~a + 1) + -(~b + 1);
        
        // Set the MSB of the result to match the MSBs of a and b
        if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin
            res[N-1] = 1'b1;
        end else begin
            res[N-1] = 1'b0;
        end
    end
    // Absolute value subtraction
    else begin
        // Determine the larger absolute value
        wire [N-1:0] abs_a = (a[N-1] == 1'b0) ? a : -(~a + 1);
        wire [N-1:0] abs_b = (b[N-1] == 1'b0) ? b : -(~b + 1);

        // Calculate the result based on the larger absolute value
        if (abs_a > abs_b) begin
            res = a - b;
        end else begin
            res = b - a;
        end

        // Set the MSB of the result based on whether it's zero or negative
        if (res == 0) begin
            res[N-1] = 1'b0;
        end else if (res[N-1] == 1'b1) begin
            res[N-1] = 1'b1;
        end else begin
            res[N-1] = 1'b0;
        end
    end
end

assign c = res;

endmodule