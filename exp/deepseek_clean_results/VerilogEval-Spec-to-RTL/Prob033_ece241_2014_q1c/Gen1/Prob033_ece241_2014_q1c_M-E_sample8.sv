module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [6:0] mag_a = a[6:0];
    wire [6:0] mag_b = b[6:0];
    wire [7:0] mag_sum = {1'b0, mag_a} + {1'b0, mag_b};
    
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_sum = sign_a ^ sign_b ^ mag_sum[7];
    
    assign s = {sign_sum, mag_sum[6:0]};
    
    // Overflow conditions:
    // 1. Signs differ but magnitude addition produces carry (mag_sum[7])
    // 2. Signs same but result sign differs
    wire overflow_diff_signs = (sign_a ^ sign_b) & mag_sum[7];
    wire overflow_same_signs = ~(sign_a ^ sign_b) & (sign_a ^ sign_sum);
    
    assign overflow = overflow_diff_signs | overflow_same_signs;
endmodule