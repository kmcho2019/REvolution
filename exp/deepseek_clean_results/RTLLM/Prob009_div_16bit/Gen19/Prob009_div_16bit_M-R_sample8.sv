module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd  // Only need 8-bit remainder
);

    // Parameterize the widths for flexibility
    parameter DIVIDEND_WIDTH = 16;
    parameter DIVISOR_WIDTH = 8;

    // Intermediate remainder wires
    wire [DIVISOR_WIDTH:0] rem [0:DIVIDEND_WIDTH];
    
    // Initialize first remainder
    assign rem[DIVIDEND_WIDTH] = {1'b0, A[DIVIDEND_WIDTH-1]};
    assign result[DIVIDEND_WIDTH-1] = (rem[DIVIDEND_WIDTH] >= {1'b0, B});

    // Generate the division stages
    genvar i;
    generate
        for (i = DIVIDEND_WIDTH-1; i > 0; i = i-1) begin : div_stages
            assign rem[i] = (rem[i+1] >= {1'b0, B}) ? 
                           (rem[i+1] - B) : rem[i+1];
            assign rem[i-1] = {rem[i][DIVISOR_WIDTH-1:0], A[i-1]};
            assign result[i-1] = (rem[i-1] >= {1'b0, B});
        end
    endgenerate

    // Final remainder calculation
    assign odd = (rem[0] >= {1'b0, B}) ? 
                (rem[0] - B) : rem[0][DIVISOR_WIDTH-1:0];

endmodule