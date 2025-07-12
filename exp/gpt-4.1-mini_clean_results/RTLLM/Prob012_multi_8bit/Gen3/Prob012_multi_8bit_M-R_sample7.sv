module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output reg [15:0] product
);
    integer i;
    reg [15:0] multiplicand_shifted;
    reg [15:0] sum;

    always @(*) begin
        sum = 16'b0;
        multiplicand_shifted = {8'b0, A};  // extend A to 16 bits
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                sum = sum + multiplicand_shifted;
            end
            multiplicand_shifted = multiplicand_shifted << 1;
        end
        product = sum;
    end

endmodule