module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Remainder wires for each stage (8-bit + carry)
    wire [8:0] rem [0:15];
    
    // Initialize first stage
    assign rem[15] = {1'b0, A[15]};
    assign result[15] = (rem[15] >= {1'b0, B});
    
    // Generate division stages
    genvar i;
    generate
        for (i = 15; i > 0; i = i - 1) begin : div_stages
            wire [8:0] next_rem = (rem[i] >= {1'b0, B}) ? (rem[i] - {1'b0, B}) : rem[i];
            assign rem[i-1] = {next_rem[7:0], A[i-1]};
            assign result[i-1] = (rem[i-1] >= {1'b0, B});
        end
    endgenerate
    
    // Final remainder calculation
    wire [7:0] final_rem = (rem[0] >= {1'b0, B}) ? (rem[0] - {1'b0, B}) : rem[0][7:0];
    
    // Output assignments
    assign odd = {8'b0, final_rem};

endmodule