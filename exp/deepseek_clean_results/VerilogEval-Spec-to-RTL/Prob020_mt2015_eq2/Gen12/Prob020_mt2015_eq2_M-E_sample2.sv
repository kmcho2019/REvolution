module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire [1:0] diff;
    wire diff0_nor, diff1_nor;
    
    // 2-bit subtraction (A - B)
    assign diff = A - B;
    
    // Check if all difference bits are zero
    nor nor0(diff0_nor, diff[0], diff[0]);
    nor nor1(diff1_nor, diff[1], diff[1]);
    
    // Final equality result
    and and0(z, diff0_nor, diff1_nor);

endmodule