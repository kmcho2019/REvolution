module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    wire [N-1:0] sum = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N-1:0] diff = (a_mag > b_mag) ? (a_mag - b_mag) : (b_mag - a_mag);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign - add magnitudes
            c = {a_sign, sum[N-2:0]};
        end else begin
            // Different signs - subtract magnitudes
            if (a_mag > b_mag) begin
                c = {a_sign, diff[N-2:0]};
            end else begin
                c = {b_sign, diff[N-2:0]};
            end
        end
    end

endmodule