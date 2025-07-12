module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    integer i;

    always @(*) begin
        product = 16'b0;
        multiplicand = A;
        multiplier = B;
        
        for (i = 0; i < 8; i = i + 1) begin
            if (multiplier[0]) begin
                product = product + multiplicand;
            end
            multiplicand = multiplicand << 1;
            multiplier = multiplier >> 1;
        end
    end

endmodule