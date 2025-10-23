module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output reg  [15:0] product
);

    integer i;
    reg [15:0] temp_product;
    reg [15:0] shifted_A;

    always @(*) begin
        temp_product = 16'b0;
        shifted_A = {8'b0, A};  // zero-extend A to 16 bits for shifting
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                temp_product = temp_product + shifted_A;
            end
            shifted_A = shifted_A << 1;  // shift left by one bit each iteration
        end
        product = temp_product;
    end

endmodule