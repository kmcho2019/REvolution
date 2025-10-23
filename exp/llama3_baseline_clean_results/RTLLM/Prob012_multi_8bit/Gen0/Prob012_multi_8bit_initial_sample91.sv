module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    reg [15:0] partial_product;
    reg [7:0] temp_A;

    always @(*) begin
        partial_product = 16'd0;
        temp_A = A;

        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                partial_product = partial_product + (temp_A << i);
            end
            temp_A = temp_A << 1;
        end

        product = partial_product;
    end

endmodule