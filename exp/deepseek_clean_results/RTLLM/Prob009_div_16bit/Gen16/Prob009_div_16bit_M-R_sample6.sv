module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    wire zero_divisor = (B == 8'b0);
    wire [8:0] B_ext = {1'b0, B};
    
    // Remainder array for each stage
    wire [8:0] rem [0:15];
    
    // First stage
    assign rem[15] = {1'b0, A[15]};
    assign result[15] = zero_divisor ? 1'b0 : (rem[15] >= B_ext);
    
    // Generate remaining stages
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_stages
            wire [8:0] next_rem = {rem[i+1][7:0], A[i]};
            assign rem[i] = (result[i+1] && !zero_divisor) ? (next_rem - B_ext) : next_rem;
            assign result[i] = zero_divisor ? 1'b0 : (next_rem >= B_ext);
        end
    endgenerate
    
    // Final remainder output
    assign odd = zero_divisor ? 8'b0 : rem[0][7:0];

endmodule