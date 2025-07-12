module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd  // Reduced to 8-bit since divisor is 8-bit
);

    wire [8:0] step [0:15];  // 9-bit steps (8-bit remainder + 1-bit from dividend)
    wire [7:0] rem [0:15];   // 8-bit remainders
    
    // Initialize first step
    assign step[0] = {1'b0, A[15]};
    assign rem[0] = (step[0] >= {1'b0, B}) ? (step[0] - B) : step[0][7:0];
    assign result[15] = (step[0] >= {1'b0, B});
    
    // Generate remaining steps
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : div_steps
            assign step[i] = {rem[i-1], A[15-i]};
            assign rem[i] = (step[i] >= {1'b0, B}) ? (step[i] - B) : step[i][7:0];
            assign result[15-i] = (step[i] >= {1'b0, B});
        end
    endgenerate
    
    // Final remainder output (8-bit)
    assign odd = rem[15];

endmodule