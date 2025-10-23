module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Intermediate remainders for each bit position
    wire [8:0] shifted_remainder [0:15];
    wire [7:0] remainder [0:15];
    
    // Initial step - MSB first
    assign shifted_remainder[0] = {1'b0, A[15]};
    assign remainder[0] = (shifted_remainder[0] >= {1'b0, B}) ? 
                         (shifted_remainder[0] - B) : shifted_remainder[0][7:0];
    assign result[15] = (shifted_remainder[0] >= {1'b0, B});

    // Generate remaining steps
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : div_steps
            // Shift remainder and append next dividend bit
            assign shifted_remainder[i] = {remainder[i-1], A[15-i]};
            
            // Comparison and subtraction logic
            assign remainder[i] = (shifted_remainder[i] >= {1'b0, B}) ? 
                                (shifted_remainder[i] - B) : shifted_remainder[i][7:0];
            assign result[15-i] = (shifted_remainder[i] >= {1'b0, B});
        end
    endgenerate

    // Final remainder output
    assign odd = remainder[15];

endmodule