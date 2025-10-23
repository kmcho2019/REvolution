module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Early sign prediction
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire sign_diff = a_sign ^ b_sign;
    
    // Magnitude extraction with conditional complement
    wire [N-1:0] a_mag = a_sign ? ~a + 1'b1 : a;
    wire [N-1:0] b_mag = b_sign ? ~b + 1'b1 : b;
    
    // Carry-save subtraction
    wire [N:0] sum, carry;
    assign {carry[0], sum[0]} = a_mag[0] + (~b_mag[0]) + 1'b1;
    genvar i;
    generate
        for (i = 1; i < N; i = i + 1) begin : cs_sub
            assign {carry[i], sum[i]} = a_mag[i] + (~b_mag[i]) + carry[i-1];
        end
    endgenerate
    assign sum[N] = carry[N-1];  // Final carry-out
    
    // Result magnitude (discard final carry)
    wire [N-1:0] result_mag = sum[N-1:0];
    
    // Result sign determination
    wire result_sign = sign_diff ? a_sign : 
                      (a_mag > b_mag) ? a_sign : ~a_sign;
    
    // Zero detection using parallel reduction
    wire is_zero = ~(|result_mag);
    
    // Final result assembly
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : 
               {result_sign, result_mag[N-2:0]};

endmodule