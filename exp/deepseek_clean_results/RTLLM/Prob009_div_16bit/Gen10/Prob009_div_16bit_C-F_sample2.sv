module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [8:0] rem_out;
    wire [8:0] step [0:15];
    
    // Initial step
    assign step[0] = {1'b0, A[15]};
    assign result[15] = (step[0] >= {1'b0, B});
    
    // Generate remaining steps
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : div_steps
            assign step[i] = {step[i-1][7:0], A[15-i]};
            assign result[15-i] = (step[i] >= {1'b0, B});
        end
    endgenerate
    
    // Final remainder calculation
    assign rem_out = (step[15] >= {1'b0, B}) ? (step[15] - {1'b0, B}) : step[15];
    
    // Output with zero-extension
    assign odd = {8'b0, rem_out[7:0]};

endmodule