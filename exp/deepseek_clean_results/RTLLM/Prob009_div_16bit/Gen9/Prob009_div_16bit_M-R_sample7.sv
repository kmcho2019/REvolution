module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [7:0] rem [0:15];  // Remainder at each step
    wire [8:0] cmp [0:15];  // Comparison operand at each step
    
    // Initialize first step
    assign cmp[15] = {1'b0, A[15]};
    assign rem[15] = (cmp[15] >= {1'b0, B}) ? (cmp[15] - B) : cmp[15][7:0];
    assign result[15] = (cmp[15] >= {1'b0, B});
    
    // Generate remaining steps
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_steps
            assign cmp[i] = {rem[i+1], A[i]};
            assign rem[i] = (cmp[i] >= {1'b0, B}) ? (cmp[i] - B) : cmp[i][7:0];
            assign result[i] = (cmp[i] >= {1'b0, B});
        end
    endgenerate
    
    // Final remainder output (zero-extended to 16 bits)
    assign odd = {8'b0, rem[0]};

endmodule