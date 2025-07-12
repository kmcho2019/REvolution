module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;

// Determine the MSBs of the input operands
wire a_sign = a[N-1];
wire b_sign = b[N-1];

// Compare the MSBs to decide whether to perform addition or subtraction
wire add_sub = ~(a_sign ^ b_sign);  // 1 for addition, 0 for subtraction

// Compare the absolute values of `a` and `b` for subtraction
wire [N-1:0] a_abs = a_sign ? -a : a;
wire [N-1:0] b_abs = b_sign ? -b : b;
wire a_greater = a_abs > b_abs;

// Perform addition or subtraction
always @(*) begin
    if (add_sub) begin
        // Addition: add the absolute values and set the MSB
        res = (a[N-1] == 1'b0) ? (a + b) : -(~(a + b) + 1'b1);
    end else begin
        // Subtraction: determine the larger absolute value and set the MSB
        if (a_greater) begin
            res = a_abs - b_abs;
        end else begin
            res = b_abs - a_abs;
        end
    end
end

// Assign the result to the output
assign c = res;

endmodule