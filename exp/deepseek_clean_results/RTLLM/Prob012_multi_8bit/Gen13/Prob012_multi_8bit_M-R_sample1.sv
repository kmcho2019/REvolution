module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate and accumulate partial products directly
    wire [15:0] pp0 = B[0] ? {8'b0, A}       : 16'b0;
    wire [15:0] pp1 = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    wire [15:0] pp2 = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    wire [15:0] pp3 = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    wire [15:0] pp4 = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    wire [15:0] pp5 = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    wire [15:0] pp6 = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    wire [15:0] pp7 = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // Accumulate partial products in stages
    wire [15:0] sum01 = pp0 + pp1;
    wire [15:0] sum23 = pp2 + pp3;
    wire [15:0] sum45 = pp4 + pp5;
    wire [15:0] sum67 = pp6 + pp7;
    
    wire [15:0] sum0123 = sum01 + sum23;
    wire [15:0] sum4567 = sum45 + sum67;
    
    // Final sum
    assign product = sum0123 + sum4567;

endmodule