module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Intermediate remainders for each bit position
    wire [8:0] remainder [0:16];
    assign remainder[16] = 9'b0;

    // Generate the division logic for each bit
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_loop
            // Current remainder with next dividend bit
            wire [8:0] shifted_remainder = {remainder[i+1][7:0], A[i]};
            
            // Comparison and subtraction logic
            wire do_subtract = (shifted_remainder >= B);
            wire [8:0] new_remainder = do_subtract ? (shifted_remainder - B) : shifted_remainder;
            
            assign remainder[i] = new_remainder;
            assign result[i] = do_subtract;
        end
    endgenerate

    // Final remainder (only need 8 bits)
    assign odd = remainder[0][7:0];

endmodule