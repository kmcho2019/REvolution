module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output reg [15:0] product
);
    integer i;
    reg [15:0] temp_product;
    reg [15:0] shifted_A;
    reg [7:0] multiplier;

    always @(*) begin
        temp_product = 16'd0;
        shifted_A = {8'd0, A};  // Extend A to 16 bits

        multiplier = B;
        for (i = 0; i < 8; i = i + 1) begin
            if (multiplier[0] == 1'b1) begin
                temp_product = temp_product + shifted_A;
            end
            shifted_A = shifted_A << 1;
            multiplier = multiplier >> 1;
        end
        product = temp_product;
    end
endmodule