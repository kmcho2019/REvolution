module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];
    wire [N-1:0] abs_a = sign_a ? -a : a;
    wire [N-1:0] abs_b = sign_b ? -b : b;
    wire [N-1:0] sum, diff;
    wire overflow_add, overflow_sub;

    // Absolute value addition when signs match
    assign sum = abs_a + abs_b;
    assign overflow_add = sum[N-1] | (sum[N-2:0] > {(N-1){1'b1}});

    // Absolute value subtraction when signs differ
    assign diff = (abs_a > abs_b) ? (abs_a - abs_b) : (abs_b - abs_a);
    assign overflow_sub = diff[N-1];

    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign - absolute addition
            if (overflow_add) begin
                c = {sign_a, {(N-1){~sign_a}}}; // Saturate to max/min
            end else begin
                c = {sign_a, sum[N-2:0]}; // Keep original sign
            end
        end else begin
            // Different signs - absolute subtraction
            if (abs_a > abs_b) begin
                c = {sign_a, diff[N-2:0]}; // Result takes sign of larger operand
            end else if (abs_b > abs_a) begin
                c = {sign_b, diff[N-2:0]};
            end else begin
                c = 0; // Equal magnitude, opposite signs = zero
            end
        end
    end

endmodule