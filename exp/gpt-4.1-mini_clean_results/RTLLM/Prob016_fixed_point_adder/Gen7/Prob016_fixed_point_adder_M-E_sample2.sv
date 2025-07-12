module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);
    // Internal register to store the result
    reg [N-1:0] res;

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Extract magnitudes (absolute values)
    // If negative, take two's complement; else direct magnitude
    wire [N-2:0] mag_a = sign_a ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] mag_b = sign_b ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Signals for magnitude addition/subtraction and comparison
    wire [N-1:0] mag_sum = mag_a + mag_b;       // could be up to N bits
    wire [N-2:0] mag_diff;                       // result of subtracting smaller from larger

    // Determine which magnitude is larger or if equal
    wire a_greater = (mag_a > mag_b);
    wire b_greater = (mag_b > mag_a);
    wire equal_mag = (mag_a == mag_b);

    // Internal wires for result sign and magnitude
    reg result_sign;
    reg [N-2:0] result_mag;

    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            // If addition overflow (bit N-1 set), truncate or saturate by trimming MSB
            // Here, we just take lower N-1 bits, fitting into width
            // Sign remains same as operands
            result_sign = sign_a;
            // sum might be N bits wide, truncate MSB (overflow ignored as per problem)
            result_mag = mag_sum[N-2:0];
        end else begin
            // Signs differ: subtract smaller magnitude from larger
            if (a_greater) begin
                // a magnitude larger => result sign = sign of a
                result_sign = sign_a;
                result_mag = mag_a - mag_b;
            end else if (b_greater) begin
                // b magnitude larger => result sign = sign of b
                result_sign = sign_b;
                result_mag = mag_b - mag_a;
            end else begin
                // magnitudes equal => result zero and sign 0
                result_sign = 1'b0;
                result_mag = { (N-1){1'b0} };
            end
        end

        // If result magnitude zero, force sign 0 (positive zero)
        if (result_mag == { (N-1){1'b0} }) begin
            result_sign = 1'b0;
        end

        // Assemble result with sign bit and magnitude
        res = {result_sign, result_mag};
    end

    assign c = res;

endmodule