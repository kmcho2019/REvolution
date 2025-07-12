module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] shifted_A;
reg [15:0] temp;
reg [7:0] count;

always @(*) begin
    result = 0;
    odd = 0;
    count = 8;

    for (int i = 0; i < 16; i++) begin
        shifted_A = A >> (8 - count);
        if (shifted_A >= B) begin
            result = result | (1 << (15 - i));
            shifted_A = shifted_A - B;
        end
        count = count - 1;
        odd = {shifted_A, odd[15:8]};
    end
end

endmodule