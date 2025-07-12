module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output reg  [15:0] product
);

    integer i;
    reg [15:0] multiplicand_shifted;

    always @* begin
        product = 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                // Shift multiplicand A by i and add to product
                multiplicand_shifted = {8'b0, A} << i;
                product = product + multiplicand_shifted;
            end
        end
    end

endmodule