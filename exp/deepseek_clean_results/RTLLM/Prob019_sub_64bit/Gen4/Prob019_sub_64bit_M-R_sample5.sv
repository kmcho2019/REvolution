module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output reg signed [63:0] result,
    output reg overflow
);

    // Local parameters for overflow conditions
    localparam POS_OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;

    always_comb begin
        // Calculate result
        result = A - B;
        
        // Detect overflow conditions
        case ({A[63], B[63], result[63]})
            3'b001: overflow = POS_OVERFLOW;  // Positive overflow
            3'b110: overflow = POS_OVERFLOW;  // Negative overflow
            default: overflow = NO_OVERFLOW;   // No overflow
        endcase
    end

endmodule