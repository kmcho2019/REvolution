module multi_8bit #(
    parameter int INPUT_WIDTH = 8,
    parameter int OUTPUT_WIDTH = 16
)(
    input   [INPUT_WIDTH-1:0] A,  // First input operand (multiplicand)
    input   [INPUT_WIDTH-1:0] B,  // Second input operand (multiplier)
    output  [OUTPUT_WIDTH-1:0] product  // Output representing the product of A and B
);

    reg [OUTPUT_WIDTH-1:0] temp_product;
    assign product = temp_product;

    always @(*) begin
        temp_product = 0;
        for (int i = 0; i < INPUT_WIDTH; i++) begin
            if (B[i] == 1'b1) begin
                temp_product = temp_product + (A << i);
            end
        end
    end

endmodule