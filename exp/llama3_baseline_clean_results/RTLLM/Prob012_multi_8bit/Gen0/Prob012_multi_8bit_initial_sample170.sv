module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    assign product = A * B;

    // Alternatively, the following code can be used for a more explicit implementation
    // of the shift-and-add method:
    // reg [15:0] prod;
    // always @(*) begin
    //     prod = 0;
    //     for (int i = 0; i < 8; i++) begin
    //         if (B[i]) begin
    //             prod = prod + (A << i);
    //         end
    //     end
    //     product = prod;
    // end

endmodule