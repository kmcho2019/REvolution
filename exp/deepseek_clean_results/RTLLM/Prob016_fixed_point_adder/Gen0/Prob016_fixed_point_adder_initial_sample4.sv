module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] res;
    reg a_sign, b_sign;
    reg [N-2:0] a_mag, b_mag;  // Magnitude parts (without sign)
    reg [N-1:0] temp_res;

    always @(*) begin
        // Extract signs and magnitudes
        a_sign = a[N-1];
        b_sign = b[N-1];
        a_mag = a[N-2:0];
        b_mag = b[N-2:0];

        if (a_sign == b_sign) begin
            // Same sign: add magnitudes and keep sign
            temp_res = {1'b0, a_mag} + {1'b0, b_mag};
            res = {a_sign, temp_res[N-2:0]};
            
            // Handle overflow (result exceeds magnitude bits)
            if (temp_res[N-1]) begin
                res = {a_sign, {N-1{1'b1}}};  // Saturate to max magnitude
            end
        end
        else begin
            // Different signs: subtract smaller from larger
            if (a_mag > b_mag) begin
                temp_res = {1'b0, a_mag} - {1'b0, b_mag};
                res = {a_sign, temp_res[N-2:0]};
            end
            else if (b_mag > a_mag) begin
                temp_res = {1'b0, b_mag} - {1'b0, a_mag};
                res = {b_sign, temp_res[N-2:0]};
            end
            else begin
                // Equal magnitudes: result is zero
                res = 0;
            end
        end

        c = res;
    end

endmodule