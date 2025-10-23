module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [15:0] temp_product;
    reg [7:0] temp_A;

    always @(A or B) begin
        temp_product = 0;
        temp_A = A;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                temp_product = temp_product + (temp_A << i);
            end
            if (i < 7) begin
                temp_A = temp_A << 1;
            end
        end
        product = temp_product;
    end

endmodule