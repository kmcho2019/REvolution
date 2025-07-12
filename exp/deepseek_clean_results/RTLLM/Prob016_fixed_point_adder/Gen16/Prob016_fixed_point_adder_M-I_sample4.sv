module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    wire sign_a = a[N-1];
    wire sign_b = b[N-1];
    wire [N-1:0] mag_a = sign_a ? -a : a;
    wire [N-1:0] mag_b = sign_b ? -b : b;
    
    wire [N-1:0] sum = mag_a + mag_b;
    wire [N-1:0] diff = (mag_a > mag_b) ? (mag_a - mag_b) : (mag_b - mag_a);
    wire diff_sign = (mag_a > mag_b) ? sign_a : sign_b;
    
    wire [N-1:0] res_mag = (sign_a == sign_b) ? sum : diff;
    wire res_sign = (sign_a == sign_b) ? sign_a : 
                   (res_mag == 0) ? 1'b0 : diff_sign;
    
    assign overflow = (sign_a == sign_b) && (res_mag[N-1] != sign_a);
    assign c = {res_sign, res_mag[N-2:0]};

endmodule