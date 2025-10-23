module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Zero-extended divisor for comparison
    wire [15:0] b_ext = {8'b0, B};

    // Generate 16 stages of division (one per bit)
    wire [15:0] rem [0:15];
    wire [15:0] quo [0:15];

    // Initialize first stage
    assign rem[15] = {15'b0, A[15]};
    assign quo[15] = (rem[15] >= b_ext) ? (16'b1 << 15) : 16'b0;
    assign rem[14] = (rem[15] >= b_ext) ? (rem[15] - b_ext) : rem[15];

    // Generate remaining stages
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_stages
            // Current remainder is previous remainder shifted left with next dividend bit
            wire [15:0] rem_shifted = {rem[i][14:0], (i > 0) ? A[i-1] : 1'b0};
            
            // Determine quotient bit and new remainder
            assign quo[i] = (rem_shifted >= b_ext) ? 
                          (quo[i+1] | (16'b1 << i)) : 
                          quo[i+1];
            assign rem[i-1] = (rem_shifted >= b_ext) ? 
                            (rem_shifted - b_ext) : 
                            rem_shifted;
        end
    endgenerate

    // Final outputs
    assign result = quo[0];
    assign odd = rem[-1];  // Last remainder from stage 0

endmodule