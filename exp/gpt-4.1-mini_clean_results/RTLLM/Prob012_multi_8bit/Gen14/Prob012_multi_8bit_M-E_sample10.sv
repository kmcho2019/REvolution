module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output reg  [15:0] product
);
    integer i;
    reg [15:0] shifted_A;
    reg [15:0] temp_product;

    always @(*) begin
        shifted_A = {8'b0, A};  // zero-extend A to 16 bits
        temp_product = 16'b0;

        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                temp_product = temp_product + shifted_A;
            shifted_A = shifted_A << 1;
        end

        product = temp_product;
    end
endmodule