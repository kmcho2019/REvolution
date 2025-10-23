module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output reg [15:0] product
);

    integer i;
    reg [15:0] partial_product;

    always @(*) begin
        partial_product = 16'b0;
        // Iterate over each bit of B
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                // Add shifted A to the partial product if bit i of B is set
                partial_product = partial_product + ( {8'b0, A} << i );
            end
        end
        product = partial_product;
    end

endmodule