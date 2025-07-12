module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd  // Reduced to 8-bit since divisor is 8-bit
);

    // Array of intermediate remainders
    wire [8:0] step [0:15];
    wire [7:0] rem [0:15];
    
    // Initialize first step
    assign step[15] = {1'b0, A[15]};
    assign rem[15] = (step[15] >= {1'b0, B}) ? (step[15] - B) : step[15][7:0];
    assign result[15] = (step[15] >= {1'b0, B});
    
    // Generate remaining steps
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_steps
            assign step[i] = {rem[i+1], A[i]};
            assign rem[i] = (step[i] >= {1'b0, B}) ? (step[i] - B) : step[i][7:0];
            assign result[i] = (step[i] >= {1'b0, B});
        end
    endgenerate
    
    // Final remainder output (8-bit)
    assign odd = rem[0];

endmodule