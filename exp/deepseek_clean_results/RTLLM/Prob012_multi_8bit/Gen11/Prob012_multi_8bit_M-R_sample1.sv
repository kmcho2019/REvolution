module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Partial products array
    wire [15:0] pp [7:0];
    
    // Generate partial products
    assign pp[0] = B[0] ? {8'b0, A} : 16'b0;
    assign pp[1] = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    assign pp[2] = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    assign pp[3] = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    assign pp[4] = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    assign pp[5] = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    assign pp[6] = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    assign pp[7] = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // Accumulate all partial products
    always @(*) begin
        product = pp[0] + pp[1] + pp[2] + pp[3] + 
                 pp[4] + pp[5] + pp[6] + pp[7];
    end

endmodule