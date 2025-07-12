module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Conditional partial product generation
    wire [15:0] pp [7:0];
    assign pp[0] = B[0] ? {8'b0, A} : 16'b0;
    assign pp[1] = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    assign pp[2] = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    assign pp[3] = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    assign pp[4] = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    assign pp[5] = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    assign pp[6] = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    assign pp[7] = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // First level CSA reduction (3:2 compression)
    wire [15:0] sum1, carry1;
    assign sum1 = pp[0] ^ pp[1] ^ pp[2];
    assign carry1 = ((pp[0] & pp[1]) | (pp[0] & pp[2]) | (pp[1] & pp[2])) << 1;

    // Second level CSA reduction
    wire [15:0] sum2, carry2;
    assign sum2 = pp[3] ^ pp[4] ^ pp[5];
    assign carry2 = ((pp[3] & pp[4]) | (pp[3] & pp[5]) | (pp[4] & pp[5])) << 1;

    // Combine first level results with remaining terms
    wire [15:0] sum3 = sum1 + carry1 + sum2;
    wire [15:0] sum4 = carry2 + pp[6] + pp[7];

    // Final addition with carry-lookahead
    assign product = sum3 + sum4;

endmodule