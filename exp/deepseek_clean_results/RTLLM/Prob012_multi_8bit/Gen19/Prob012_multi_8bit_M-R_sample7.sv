module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Partial products
    wire [15:0] pp0 = B[0] ? {8'b0, A} : 16'b0;
    wire [15:0] pp1 = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    wire [15:0] pp2 = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    wire [15:0] pp3 = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    wire [15:0] pp4 = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    wire [15:0] pp5 = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    wire [15:0] pp6 = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    wire [15:0] pp7 = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // Accumulation logic
    always @(*) begin
        product = 16'b0;
        if (B[0]) product = product + pp0;
        if (B[1]) product = product + pp1;
        if (B[2]) product = product + pp2;
        if (B[3]) product = product + pp3;
        if (B[4]) product = product + pp4;
        if (B[5]) product = product + pp5;
        if (B[6]) product = product + pp6;
        if (B[7]) product = product + pp7;
    end

endmodule