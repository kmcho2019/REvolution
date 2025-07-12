module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    result = 0;
    odd = A;
    for (int i = 15; i >= 7; i--) begin
        if (odd[15:8] >= B) begin
            result[15-i+7] = 1;
            odd = (odd[15:8] - B) << 8 | odd[7:0];
        end else begin
            odd = odd << 1;
        end
    end
    odd = odd[7:0];
end

endmodule