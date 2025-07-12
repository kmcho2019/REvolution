module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    reg [N-1:0] res;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    wire [N-1:0] a_abs = {1'b0, a_mag};
    wire [N-1:0] b_abs = {1'b0, b_mag};
    wire [N-1:0] sum;
    wire [N-1:0] diff;

    // Absolute addition
    assign sum = a_abs + b_abs;

    // Absolute subtraction (always positive result)
    assign diff = (a_mag > b_mag) ? (a_abs - b_abs) : (b_abs - a_abs);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign - add magnitudes and keep sign
            res = {a_sign, sum[N-2:0]};
        end else begin
            // Different signs - subtract and set sign
            if (a_mag > b_mag) begin
                res = {1'b0, diff[N-2:0]};
            end else if (b_mag > a_mag) begin
                res = {1'b1, diff[N-2:0]};
            end else begin
                // Magnitudes equal, result is zero
                res = {1'b0, {(N-1){1'b0}}};
            end
        end
    end

    assign c = res;

endmodule