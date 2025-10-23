module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Zero-extended divisor
    wire [15:0] b_ext = {8'b0, B};

    // Binary search steps
    wire [15:0] quotient_guess [0:3];
    wire [15:0] product [0:3];
    wire [15:0] remainder [0:3];
    wire [1:0] select;

    // Stage 1: Coarse search (MSBs)
    assign quotient_guess[0] = 16'h8000;  // 0.5
    assign quotient_guess[1] = 16'hC000;  // 0.75
    assign quotient_guess[2] = 16'h4000;  // 0.25
    assign quotient_guess[3] = 16'h0000;  // 0.0

    // Parallel multiply and compare
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : mult_compare
            assign product[i] = quotient_guess[i] * b_ext;
            assign remainder[i] = A - product[i];
        end
    endgenerate

    // Hierarchical comparator
    wire cmp_0 = (remainder[0] >= 0) && (remainder[0] < b_ext);
    wire cmp_1 = (remainder[1] >= 0) && (remainder[1] < b_ext);
    wire cmp_2 = (remainder[2] >= 0) && (remainder[2] < b_ext);
    wire cmp_3 = (remainder[3] >= 0);

    // Selection logic
    assign select[1] = cmp_1 | cmp_0;
    assign select[0] = cmp_0 | cmp_2;

    // Final selection
    assign result = (select == 2'b11) ? quotient_guess[0] :
                   (select == 2'b10) ? quotient_guess[1] :
                   (select == 2'b01) ? quotient_guess[2] :
                   quotient_guess[3];

    assign odd = (select == 2'b11) ? remainder[0] :
                (select == 2'b10) ? remainder[1] :
                (select == 2'b01) ? remainder[2] :
                remainder[3];

    // Refinement stages (can be expanded for more precision)
    wire [15:0] refined_quotient;
    wire [15:0] refined_remainder;

    // Second stage binary search around initial guess
    assign refined_quotient = result + 
                            ((odd >= (b_ext >> 1)) ? (result >> 1) : 16'b0) +
                            ((odd >= (b_ext >> 2)) ? (result >> 2) : 16'b0);

    assign refined_remainder = A - (refined_quotient * b_ext);

    // Final outputs
    assign result = (refined_remainder >= 0) ? refined_quotient : result;
    assign odd = (refined_remainder >= 0) ? refined_remainder : odd;

endmodule