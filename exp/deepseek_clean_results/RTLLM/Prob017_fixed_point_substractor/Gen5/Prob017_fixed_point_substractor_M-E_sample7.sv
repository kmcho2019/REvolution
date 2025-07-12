module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

// Internal signals
reg a_sign, b_sign;
reg [N-2:0] a_mag, b_mag;
reg res_sign;
reg [N-2:0] res_mag;
wire a_is_zero = ~|a[N-2:0];
wire b_is_zero = ~|b[N-2:0];

always @(*) begin
    // Convert to sign-magnitude format
    a_sign = a[N-1];
    b_sign = b[N-1];
    a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    b_mag = b_sign ? -b[N-2:0] : b[N-2:0];

    // Special case: subtraction with zero
    if (a_is_zero) begin
        res_sign = ~b_sign;
        res_mag = b_mag;
    end
    else if (b_is_zero) begin
        res_sign = a_sign;
        res_mag = a_mag;
    end
    // Same sign subtraction
    else if (a_sign == b_sign) begin
        res_sign = a_sign;
        if (a_mag >= b_mag) begin
            res_mag = a_mag - b_mag;
        end
        else begin
            res_mag = b_mag - a_mag;
            res_sign = ~res_sign;
        end
    end
    // Different sign subtraction (effectively addition)
    else begin
        res_mag = a_mag + b_mag;
        res_sign = (a_mag > b_mag) ? a_sign : b_sign;
    end

    // Convert back to two's complement
    if (res_mag == 0) begin
        c = 0;  // Explicit zero handling
    end
    else begin
        c[N-1] = res_sign;
        c[N-2:0] = res_sign ? -res_mag : res_mag;
    end
end

endmodule