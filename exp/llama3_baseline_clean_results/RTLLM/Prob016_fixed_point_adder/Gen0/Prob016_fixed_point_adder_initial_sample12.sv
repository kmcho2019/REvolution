module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register to store the result

// Determine the operation based on the MSBs of a and b
always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same signs, add absolute values
        if (a[N-1] == 1'b0) begin  // Both positive
            res = a + b;
        end else begin  // Both negative
            res = -a - b;
        end
    end else begin  // Different signs, subtract absolute values
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a positive, b negative
            if (a >= -b) begin
                res = a + b;  // Result is positive
            end else begin
                res = -(-a - b);  // Result is negative
            end
        end else begin  // a negative, b positive
            if (-a >= b) begin
                res = -a - b;  // Result is negative
            end else begin
                res = -(b + a);  // Result is positive
            end
        end
    end
end

// Assign the result to the output
assign c = res;

endmodule