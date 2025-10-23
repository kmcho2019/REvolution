module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd  // Reduced to match divisor width
);

    wire [8:0] stage [0:16];  // 9-bit stages (8 remainder + 1 carry)
    wire [15:0] quotient;

    // Initialize stage 0
    assign stage[0] = 9'b0;

    // Unrolled division stages
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_stages
            wire [8:0] shifted = {stage[15-i][7:0], A[i]};
            wire do_subtract = shifted >= {1'b0, B};
            
            assign quotient[i] = do_subtract;
            assign stage[16-i] = do_subtract ? (shifted - {1'b0, B}) : shifted;
        end
    endgenerate

    // Output assignments
    assign result = quotient;
    assign odd = stage[16][7:0];  // Final remainder (8-bit)

endmodule