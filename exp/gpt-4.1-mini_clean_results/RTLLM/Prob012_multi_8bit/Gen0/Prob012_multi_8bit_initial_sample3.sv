module multi_8bit(
    input  wire [7:0] A,
    input  wire [7:0] B,
    output reg  [15:0] product
);
    integer i;
    reg [15:0] temp_product;
    reg [15:0] shifted_A;

    always @(*) begin
        temp_product = 16'd0;
        shifted_A = {8'd0, A};  // Place A in lower 8 bits of 16-bit reg
        for(i = 0; i < 8; i = i + 1) begin
            if(B[i])
                temp_product = temp_product + shifted_A;
            shifted_A = shifted_A << 1;
        end
        product = temp_product;
    end
endmodule