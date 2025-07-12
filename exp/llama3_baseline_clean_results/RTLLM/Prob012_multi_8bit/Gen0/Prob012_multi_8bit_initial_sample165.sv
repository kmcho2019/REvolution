module multi_8bit(A, B, product);
    input [7:0] A;
    input [7:0] B;
    output [15:0] product;
    reg [15:0] product;

    always @(A or B) begin
        product = 0;
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                product = product + (A << i);
            end
        end
    end
endmodule