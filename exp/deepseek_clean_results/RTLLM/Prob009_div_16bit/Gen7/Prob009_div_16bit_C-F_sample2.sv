module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Remainder array (17 stages x 9 bits)
    wire [8:0] remainder [0:16];
    assign remainder[16] = 9'b0;

    // Generate 16 processing stages
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_stage
            // Current remainder with next dividend bit
            wire [8:0] current_remainder = {remainder[i+1][7:0], A[i]};
            
            // Comparison and subtraction logic
            wire do_subtract = (current_remainder >= B);
            wire [8:0] next_remainder = do_subtract ? (current_remainder - B) : current_remainder;
            
            assign remainder[i] = next_remainder;
            assign result[i] = do_subtract;
        end
    endgenerate

    // Final remainder output (16 bits, upper 8 bits zero)
    assign odd = {8'b0, remainder[0][7:0]};

endmodule