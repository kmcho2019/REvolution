module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    integer i;
    reg [15:0] shifted_A;
    reg [15:0] temp_product;

    always @(*) begin
        temp_product = 16'b0;
        shifted_A = {8'b0, A};
        
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                temp_product = temp_product + shifted_A;
            end
            shifted_A = shifted_A << 1;
        end
        
        product = temp_product;
    end

endmodule