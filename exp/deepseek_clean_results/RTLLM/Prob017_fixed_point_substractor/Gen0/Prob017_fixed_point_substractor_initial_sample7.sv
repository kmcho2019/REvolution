module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    reg signed [N-1:0] res;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    always @(*) begin
        // Same sign case
        if (a_sign == b_sign) begin
            res = a - b;
            // If result is zero, force positive sign
            if (res == 0) begin
                res[N-1] = 1'b0;
            end
        end
        // Different sign case
        else begin
            if (a_sign == 0) begin  // a positive, b negative
                res = a_mag + b_mag;
                res[N-1] = (a_mag >= b_mag) ? 1'b0 : 1'b1;
            end
            else begin  // a negative, b positive
                res = a_mag + b_mag;
                res[N-1] = (b_mag >= a_mag) ? 1'b0 : 1'b1;
            end
        end
        c = res;
    end

endmodule