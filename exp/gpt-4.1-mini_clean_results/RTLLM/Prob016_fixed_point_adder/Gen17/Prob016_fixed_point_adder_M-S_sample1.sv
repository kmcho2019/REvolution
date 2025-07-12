module fixed_point_adder #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Get magnitudes as unsigned by inverting two's complement if negative
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    reg [N-1:0] sum;        // For addition with carry
    reg [N-2:0] diff;       // For difference magnitude
    reg result_sign;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes
            sum = {1'b0, a_mag} + {1'b0, b_mag}; // N bits sum to catch carry
            result_sign = a_sign;
            // Truncate to N-1 bits magnitude, discard carry (overflow)
            c = {result_sign, sum[N-2:0]};
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_mag == b_mag) begin
                // Result zero, sign 0
                c = {1'b0, {(N-1){1'b0}}};
            end else if (a_mag > b_mag) begin
                diff = a_mag - b_mag;
                result_sign = a_sign;
                c = {result_sign, diff};
            end else begin
                diff = b_mag - a_mag;
                result_sign = b_sign;
                c = {result_sign, diff};
            end
        end
    end

endmodule