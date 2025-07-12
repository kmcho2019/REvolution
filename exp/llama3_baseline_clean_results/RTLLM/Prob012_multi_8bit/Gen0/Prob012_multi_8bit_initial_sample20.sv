module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    always @(A or B) begin
        reg [15:0] temp_product;
        reg [7:0] shifted_A;
        reg [7:0] temp_B;
        
        temp_product = 0;
        shifted_A = A;
        temp_B = B;
        
        for (int i = 0; i < 8; i++) begin
            if (temp_B[0] == 1) begin
                temp_product = temp_product + {8'd0, shifted_A};
            end
            shifted_A = shifted_A << 1;
            temp_B = temp_B >> 1;
        end
        
        product = temp_product;
    end

endmodule