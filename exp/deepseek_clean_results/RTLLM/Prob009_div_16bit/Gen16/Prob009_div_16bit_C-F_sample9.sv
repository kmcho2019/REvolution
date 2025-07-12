module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Intermediate remainders - only need 8 bits for each stage
    wire [7:0] rem [0:16];
    assign rem[16] = 8'b0;

    // Generate all division stages in parallel
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_stages
            // Concatenate previous remainder with current dividend bit
            wire [8:0] current = {rem[i+1], A[i]};
            
            // Comparison and subtraction logic
            wire do_subtract = (current >= {1'b0, B});
            wire [7:0] new_rem = do_subtract ? 
                                current[7:0] - B : 
                                current[7:0];
            
            assign rem[i] = new_rem;
            assign result[i] = do_subtract;
        end
    endgenerate

    // Final remainder with zero-division check
    assign odd = (B == 8'b0) ? 8'b0 : rem[0];

endmodule