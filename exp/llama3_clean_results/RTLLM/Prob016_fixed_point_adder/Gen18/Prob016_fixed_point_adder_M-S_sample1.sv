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
    // Calculate the absolute values of the inputs
    reg [N-1:0] abs_a, abs_b;
    abs_a = a[N-1] ? ~a + 1 : a;
    abs_b = b[N-1] ? ~b + 1 : b;

    // Perform addition or subtraction based on the MSBs
    reg [N:0] sum;
    sum = (a[N-1] == b[N-1]) ? abs_a + abs_b : (a[N-1] == 1'b0 && b[N-1] == 1'b1) ? abs_a - abs_b : abs_b - abs_a;

    // Handle overflow and determine the sign of the result
    reg [N-1:0] result;
    if (sum[N]) begin
        result = {1'b1, {N-1{1'b1}}}; // Overflow, set to max negative value
    end else begin
        result = sum[N-1:0];
        if (a[N-1] != b[N-1] && sum[N-1:0] == 0) begin
            result = 0; // If subtraction results in zero, ensure output is zero
        end else if ((a[N-1] == 1'b1 && b[N-1] == 1'b0 && abs_a < abs_b) || (a[N-1] == 1'b0 && b[N-1] == 1'b1 && abs_b < abs_a)) begin
            result = {1'b1, {N-1{1'b0}}}; // Negative result from subtraction, set sign bit
        end
    end

    // Assign the result
    res = result;
end

assign c = res;

endmodule