module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Constants for saturation
    localparam MAX_POS = {1'b0, {(N-1){1'b1}};
    localparam MAX_NEG = {1'b1, {(N-1){1'b0}};

    // Internal signals
    wire [N-1:0] sum;
    wire [N-1:0] diff;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire sum_overflow;

    // Calculate sum and detect overflow
    assign sum = a + b;
    assign sum_overflow = (a_sign == b_sign) && (sum[N-1] != a_sign);

    // Absolute difference calculation
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;
    assign diff = (a_mag > b_mag) ? (a_mag - b_mag) : (b_mag - a_mag);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign case
            if (sum_overflow) begin
                // Saturate to max positive or negative
                c = a_sign ? MAX_NEG : MAX_POS;
            end else begin
                c = sum;
            end
        end else begin
            // Different signs case
            if (a_mag > b_mag) begin
                c = a_sign ? {1'b1, diff[N-2:0]} : {1'b0, diff[N-2:0]};
            end else begin
                c = b_sign ? {1'b1, diff[N-2:0]} : {1'b0, diff[N-2:0]};
            end
        end
    end

endmodule