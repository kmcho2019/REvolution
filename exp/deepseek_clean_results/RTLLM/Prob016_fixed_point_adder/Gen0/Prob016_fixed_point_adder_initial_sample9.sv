module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
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

always @(*) begin
    if (a_sign == b_sign) begin
        // Same signs: add magnitudes and keep sign
        res = {a_sign, a_mag + b_mag};
    end
    else begin
        // Different signs: subtract smaller from larger
        if (a_mag > b_mag) begin
            res = {a_sign, a_mag - b_mag};
        end
        else if (b_mag > a_mag) begin
            res = {b_sign, b_mag - a_mag};
        end
        else begin
            // Equal magnitudes: result is zero
            res = 0;
        end
    end
    
    // Handle overflow by saturating
    if (a_sign == b_sign && res[N-1] != a_sign) begin
        // Overflow occurred
        res = a_sign ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
    end
    
    c = res;
end

endmodule