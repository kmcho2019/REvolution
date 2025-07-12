module multi_8bit(
    input   [7:0] A,  
    input   [7:0] B,  
    output  [15:0] product  
);

    reg [15:0] temp_product;
    assign product = temp_product;

    always @(*) begin
        temp_product = 0;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                temp_product = temp_product + (A << i);
            end
        end
    end

endmodule