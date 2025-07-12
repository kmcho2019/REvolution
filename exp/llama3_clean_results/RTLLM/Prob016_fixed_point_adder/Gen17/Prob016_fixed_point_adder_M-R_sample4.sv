module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of the inputs
    reg sign_a, sign_b;
    sign_a = a[N-1];
    sign_b = b[N-1];

    // Calculate the absolute values of the inputs
    reg [N-1:0] abs_a, abs_b;
    abs_a = sign_a ? {1'b0, {N-1{1'b1}} ^ a} + 1 : a;
    abs_b = sign_b ? {1'b0, {N-1{1'b1}} ^ b} + 1 : b;

    // Perform addition or subtraction based on the MSBs
    reg add_op;
    add_op = sign_a == sign_b;
    reg [N:0] sum;
    sum = add_op ? abs_a + abs_b : (abs_a > abs_b) ? abs_a - abs_b : abs_b - abs_a;

    // Handle overflow
    reg overflow;
    overflow = sum[N];

    // Determine the sign of the result
    reg sign_c;
    sign_c = (add_op) ? sign_a : (abs_a > abs_b) ? 1'b0 : (sum[N-1] == 0 && sum[N-2:0] == 0) ? 1'b0 : 1'b1;

    // Assign the result, handling overflow and sign
    if (overflow) begin
        res = {1'b1, {N-1{1'b1}}};
    end else begin
        res = (sign_c) ? {1'b1, sum[N-1:1]} : {1'b0, sum[N-1:1]};
    end
end

assign c = res;

endmodule