module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [15:0] multiplicand;
    reg [7:0] multiplier;
    integer i;

    always @(*) begin
        product = 16'b0;
        multiplicand = {8'b0, A};
        multiplier = B;

        for (i = 0; i < 8; i = i + 1) begin
            if (multiplier[i]) begin
                product = product + (multiplicand << i);
            end
        end
    end

endmodule