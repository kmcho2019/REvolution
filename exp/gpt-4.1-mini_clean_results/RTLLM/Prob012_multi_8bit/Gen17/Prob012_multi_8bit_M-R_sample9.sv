module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    wire [15:0] sums [0:8];
    integer i;

    // Initialize sums[0] = 0
    assign sums[0] = 16'd0;

    // Generate combinational partial sums by processing each bit of B
    // If B[i] is set, add (A << i) to the previous sum; else keep previous sum.
    generate
        for (i = 0; i < 8; i = i + 1) begin : SHIFT_ADD_LOOP
            assign sums[i+1] = B[i] ? (sums[i] + (16'd0 | (A << i))) : sums[i];
        end
    endgenerate

    // The final product is the accumulated sum after processing all bits
    assign product = sums[8];

endmodule