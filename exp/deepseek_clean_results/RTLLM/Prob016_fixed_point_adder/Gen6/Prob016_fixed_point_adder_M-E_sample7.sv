module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Sign-magnitude conversion
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];

    // Parallel arithmetic paths
    wire [N-1:0] add_path, sub_path;
    
    // Addition path (same signs)
    wire [N-1:0] raw_add = {1'b0, a_mag} + {1'b0, b_mag};
    wire add_ovf = raw_add[N-1];
    assign add_path = add_ovf ? {1'b0, {(N-1){1'b1}}} : 
                     {a_sign, raw_add[N-2:0]};

    // Subtraction path (different signs)
    wire a_larger = (a_mag > b_mag);
    wire [N-2:0] sub_mag = a_larger ? (a_mag - b_mag) : (b_mag - a_mag);
    wire sub_sign = a_larger ? a_sign : b_sign;
    assign sub_path = {sub_sign, sub_mag};

    // Fractional overflow detection
    wire frac_ovf_add = (raw_add[Q-1] & (a_mag[Q-1] | b_mag[Q-1]));
    wire frac_ovf_sub = (sub_mag[Q-1] & (a_mag[Q-1] ^ b_mag[Q-1]));

    // Result selection and saturation
    always @* begin
        if (a_sign == b_sign) begin
            c = frac_ovf_add ? {a_sign, {(N-1){1'b1}}} : add_path;
        end
        else begin
            if (frac_ovf_sub) begin
                c = {sub_sign, {(N-1){1'b1}}};
            end
            else if (sub_mag == 0) begin
                c = 0;  // Exact zero case
            end
            else begin
                c = sub_path;
            end
        end
    end

endmodule