module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

wire a_sign = a[N-1];
wire b_sign = b[N-1];
wire signed [N-1:0] a_abs = a_sign ? -a : a;
wire signed [N-1:0] b_abs = b_sign ? -b : b;
wire signed [N-1:0] diff;

always @(*) begin
    // Same sign case
    if (a_sign == b_sign) begin
        diff = a - b;
        c = diff;
    end
    // Different sign case (a positive, b negative)
    else if (!a_sign && b_sign) begin
        diff = a_abs + b_abs;
        c = (a_abs >= b_abs) ? diff : -diff;
    end
    // Different sign case (a negative, b positive)
    else begin
        diff = a_abs + b_abs;
        c = (a_abs > b_abs) ? -diff : diff;
    end

    // Explicit zero handling
    if (diff == 0)
        c = 0;
end

endmodule