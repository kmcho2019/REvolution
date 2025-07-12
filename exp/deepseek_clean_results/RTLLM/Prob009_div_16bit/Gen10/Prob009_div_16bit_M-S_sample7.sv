module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [8:0] remainder;
    wire [8:0] shifted_remainder [0:15];
    wire [8:0] next_remainder [0:15];
    wire do_subtract [0:15];

    // Initialize the first remainder
    assign shifted_remainder[15] = {8'b0, A[15]};

    // Division logic for each bit
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_loop
            assign do_subtract[i] = (shifted_remainder[i] >= B);
            assign next_remainder[i] = do_subtract[i] ? (shifted_remainder[i] - B) : shifted_remainder[i];
            assign result[i] = do_subtract[i];
            
            if (i > 0) begin
                assign shifted_remainder[i-1] = {next_remainder[i][7:0], A[i-1]};
            end
        end
    endgenerate

    // Final remainder
    assign odd = {8'b0, next_remainder[0][7:0]};

endmodule