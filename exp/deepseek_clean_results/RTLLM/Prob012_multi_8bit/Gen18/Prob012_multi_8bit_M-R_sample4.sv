module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    always @(*) begin
        reg [15:0] temp_product = 0;
        reg [15:0] shifted_A = {8'b0, A};
        
        for (integer i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                temp_product = temp_product + shifted_A;
            end
            shifted_A = shifted_A << 1;
        end
        
        product = temp_product;
    end

endmodule