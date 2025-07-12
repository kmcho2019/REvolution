module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);
    // Extend divisor to 9 bits for comparison (MSB zero padded)
    wire [8:0] divisor_ext = {1'b0, B};
    
    // Arrays for intermediate remainders and quotient bits
    // remainder_w[i]: remainder after processing bit i-1 (0 to 16)
    // quotient_w[i]: quotient bit at position i (0 to 15)
    
    // 17 remainders (for bits 0 to 16), 16 quotient bits
    wire [8:0] remainder_w [0:16];
    wire quotient_w [15:0];
    
    // Initialize first remainder with zero
    assign remainder_w[0] = 9'd0;
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : div_loop
            // Shift left remainder by 1, bring in the current bit of A (MSB first)
            wire [8:0] shifted = {remainder_w[i][7:0], A[15 - i]};
            
            // If remainder >= divisor, subtract divisor and set quotient bit to 1
            assign quotient_w[15 - i] = (shifted >= divisor_ext) ? 1'b1 : 1'b0;
            
            assign remainder_w[i+1] = (shifted >= divisor_ext) ? (shifted - divisor_ext) : shifted;
        end
    endgenerate
    
    // Concatenate quotient bits into the result
    assign result = {quotient_w[15], quotient_w[14], quotient_w[13], quotient_w[12],
                     quotient_w[11], quotient_w[10], quotient_w[9], quotient_w[8],
                     quotient_w[7], quotient_w[6], quotient_w[5], quotient_w[4],
                     quotient_w[3], quotient_w[2], quotient_w[1], quotient_w[0]};
                     
    // The final remainder_w[16] holds the remainder in 9 bits; zero-extend to 16 bits for odd output
    assign odd = {8'd0, remainder_w[16][7:0]};
    
endmodule