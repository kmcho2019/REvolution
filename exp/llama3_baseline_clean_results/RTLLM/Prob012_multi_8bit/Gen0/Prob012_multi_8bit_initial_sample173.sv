module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    always @(*) begin
        product = 0;
        reg [7:0] temp_A;
        temp_A = A;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                product = product + (temp_A << i);
            end
            temp_A = temp_A << 1;
        end
    end

endmodule