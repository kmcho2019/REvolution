module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] res;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    wire [N-1:0] a_abs = {1'b0, a_mag};
    wire [N-1:0] b_abs = {1'b0, b_mag};
    wire [N-1:0] sum, diff;
    wire a_gt_b;

    // Magnitude comparison
    assign a_gt_b = (a_mag > b_mag);

    // Addition and subtraction blocks
    assign sum = a_abs + b_abs;
    assign diff = a_gt_b ? (a_abs - b_abs) : (b_abs - a_abs);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes and keep sign
            res = {a_sign, sum[N-2:0]};
        end else begin
            // Different signs: subtract and set sign
            if (a_mag == b_mag) begin
                res = 0;  // Equal magnitude, result is zero
            end else begin
                res = {a_gt_b ? a_sign : b_sign, diff[N-2:0]};
            end
        end

        // Handle overflow for same-sign addition
        if (a_sign == b_sign && sum[N-1]) begin
            res = {a_sign, {N-1{!a_sign}}};  // Saturate to max positive/negative
        end

        c = res;
    end

endmodule