module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd  // Reduced to 8-bit remainder
);

    // Array for intermediate remainders (9-bit to handle carry)
    wire [8:0] rem [0:7];  // Only need 8 steps now (16 bits / 2 bits per step)
    
    // Process 2 bits at a time (radix-4)
    assign rem[0] = {1'b0, A[15:14]};
    assign result[15] = (rem[0] >= {1'b0, B});
    assign result[14] = ((rem[0] - (result[15] ? B : 8'b0)) >= {1'b0, B});
    
    // Generate remaining steps
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : div_steps
            wire [8:0] partial_rem = {rem[i-1] - (result[17-2*i] ? B : 8'b0), 
                       A[15-2*i]};
            assign rem[i] = partial_rem - (result[16-2*i] ? B : 8'b0);
            assign result[15-2*i] = (partial_rem >= {1'b0, B});
            assign result[14-2*i] = (rem[i] >= {1'b0, B});
        end
    endgenerate
    
    // Final remainder output (only need lower 8 bits)
    assign odd = rem[7][7:0];

endmodule