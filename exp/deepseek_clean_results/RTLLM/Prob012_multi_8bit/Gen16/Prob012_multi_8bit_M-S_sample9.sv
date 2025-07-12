module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [15:0] multiplicand;
    reg [2:0] bit_counter;
    
    always @(*) begin
        product = 16'b0;
        multiplicand = {8'b0, A};
        bit_counter = 3'b0;
        
        for (bit_counter = 0; bit_counter < 8; bit_counter = bit_counter + 1) begin
            if (B[bit_counter]) begin
                product = product + multiplicand;
            end
            multiplicand = multiplicand << 1;
        end
    end

endmodule