module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] remainder
);

    // Temporary wires for each division step
    wire [8:0] current_step [0:15];  // 8-bit remainder + 1 new bit
    wire [7:0] next_remainder [0:15];
    
    // Initial step (MSB first)
    assign current_step[0] = {1'b0, A[15]};
    assign next_remainder[0] = (current_step[0] >= {1'b0, B}) ? 
                              (current_step[0] - B) : current_step[0][7:0];
    assign result[15] = (current_step[0] >= {1'b0, B});

    // Generate remaining 15 steps
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : div_steps
            assign current_step[i] = {next_remainder[i-1], A[15-i]};
            assign next_remainder[i] = (current_step[i] >= {1'b0, B}) ? 
                                     (current_step[i] - B) : current_step[i][7:0];
            assign result[15-i] = (current_step[i] >= {1'b0, B});
        end
    endgenerate

    // Final remainder output
    assign remainder = next_remainder[15];

endmodule