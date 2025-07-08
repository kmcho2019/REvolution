module multi_8bit(
    input  [7:0] A,
    input  [7:0] B,
    output reg [15:0] product
);

    integer i;
    reg [15:0] multiplicand_shifted;

    always @(*) begin
        product = 16'd0;
        multiplicand_shifted = {8'd0, A};  // Extend A to 16 bits
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                product = product + (multiplicand_shifted << i);
            end
        end
    end

endmodule