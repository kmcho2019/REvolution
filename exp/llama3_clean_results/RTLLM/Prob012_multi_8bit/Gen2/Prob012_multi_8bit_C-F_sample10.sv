module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    always @(*) begin
        product = 0;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                product = product + ({8'b0, A} << i); // Ensure A is zero-extended before shifting
            end
        end
    end

endmodule