module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [7:0] remainder [0:15];
    wire [7:0] next_remainder;
    wire [8:0] initial_compare;

    // Initial comparison for MSB
    assign initial_compare = {1'b0, A[15]};
    assign remainder[15] = (initial_compare >= {1'b0, B}) ? 
                          (initial_compare - {1'b0, B}) : initial_compare[7:0];
    assign result[15] = (initial_compare >= {1'b0, B});

    // Generate loop for remaining bits
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_loop
            assign next_remainder = {remainder[i+1][6:0], A[i]};
            assign remainder[i] = (next_remainder >= B) ? 
                                (next_remainder - B) : next_remainder;
            assign result[i] = (next_remainder >= B);
        end
    endgenerate

    // Handle division by zero and final remainder output
    assign odd = (B == 8'b0) ? 16'b0 : {8'b0, remainder[0]};

endmodule