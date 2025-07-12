module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    reg [15:0] temp_product;
    integer i;

    always @(A or B) begin
        temp_product = 0;
        for(i = 0; i < 8; i = i + 1) begin
            if(B[i] == 1'b1) begin
                temp_product = temp_product + (A << i);
            end
        end
        product = temp_product;
    end

endmodule