module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output wire [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // MSBs of a and b are the same
        // Absolute value addition
        res = a + b;
        if (res >= (1 << N)) begin  // Overflow handling
            res = {1'b1, {N-1{1'b0}}};  // Set MSB to 1 and others to 0 on overflow
        end
    end else begin  // MSBs of a and b are different
        // Determine larger absolute value
        if (a > b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
        // Adjust MSB according to the result
        if (res == 0) begin
            res = {N{1'b0}};  // Set all bits to 0 if result is zero
        end else if (res < 0) begin
            res = {1'b1, {N-1{1'b0}}};  // Set MSB to 1 if result is negative
        end
    end
end

assign c = res;  // Assign result to output port

endmodule