module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [8:0] temp [0:15];  // Temporary storage for each step
    wire [7:0] remainder;

    // Initialize first step
    assign temp[0] = {1'b0, A[15]};
    assign result[15] = (temp[0] >= {1'b0, B});

    // Generate remaining steps
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : div_steps
            assign temp[i] = {(temp[i-1] >= {1'b0, B}) ? (temp[i-1] - B) : temp[i-1][7:0], A[15-i]};
            assign result[15-i] = (temp[i] >= {1'b0, B});
        end
    endgenerate

    // Final remainder calculation
    assign remainder = (temp[15] >= {1'b0, B}) ? (temp[15] - B) : temp[15][7:0];
    assign odd = {8'b0, remainder};

endmodule