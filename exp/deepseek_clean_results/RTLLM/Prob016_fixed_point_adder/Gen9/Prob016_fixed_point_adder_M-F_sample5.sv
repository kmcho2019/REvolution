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
    wire [N:0] sum;
    wire overflow;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign - add magnitudes
            sum = a_abs + b_abs;
            overflow = sum[N] | sum[N-1];
            
            if (overflow) begin
                // Saturate to max/min representable value
                res = a_sign ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
            end else begin
                res = {a_sign, sum[N-2:0]};
            end
        end else begin
            // Different signs - subtract smaller from larger
            if (a_mag >= b_mag) begin
                sum = a_abs - b_abs;
                res = {a_sign, sum[N-2:0]};
            end else begin
                sum = b_abs - a_abs;
                res = {b_sign, sum[N-2:0]};
            end
        end
    end

    assign c = res;

endmodule