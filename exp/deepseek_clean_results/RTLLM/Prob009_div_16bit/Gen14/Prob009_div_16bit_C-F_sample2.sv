module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Pre-calculate extended divisor for all comparisons
    wire [8:0] B_ext = {1'b0, B};
    
    // Array of intermediate steps and remainders
    wire [8:0] step [0:15];
    wire [7:0] rem [0:15];
    
    // Initialize first step
    assign step[15] = {1'b0, A[15]};
    assign rem[15] = (step[15] >= B_ext) ? (step[15] - B_ext)[7:0] : step[15][7:0];
    assign result[15] = (step[15] >= B_ext);
    
    // Generate remaining steps using more compact notation
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_steps
            assign step[i] = {rem[i+1], A[i]};
            assign rem[i] = (step[i] >= B_ext) ? (step[i] - B_ext)[7:0] : step[i][7:0];
            assign result[i] = (step[i] >= B_ext);
        end
    endgenerate
    
    // Final remainder output (only need 8 bits, but maintain 16-bit output per spec)
    assign odd = {8'b0, rem[0]};

endmodule