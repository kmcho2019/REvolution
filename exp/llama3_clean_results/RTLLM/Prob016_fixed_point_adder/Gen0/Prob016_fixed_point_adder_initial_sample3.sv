module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits (including integer and fractional parts)
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // Temporary register to store the result

always @(*) begin
    // Determine if the MSBs of a and b are the same (both positive or both negative)
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = (a[N-1] == 1'b0) ? (a + b) : -(~a + 1) + -(~b + 1);
    end else begin
        // Absolute value subtraction
        if ((a[N-1] == 1'b0 && a > b) || (a[N-1] == 1'b1 && -(~a + 1) > -(~b + 1))) begin
            res = (a[N-1] == 1'b0) ? (a - b) : -(~a + 1) - -(~b + 1);
        end else begin
            res = (b[N-1] == 1'b0) ? (b - a) : -(~b + 1) - -(~a + 1);
        end
    end

    // Handle overflow by clipping the result to the N-bit range
    if (res[N-1] == 1'b1 && res < 0) begin
        c = {N{1'b1}};
    end else if (res[N-1] == 1'b0 && res >= (1 << N)) begin
        c = {N{1'b1}};
    end else begin
        c = res;
    end
end

endmodule