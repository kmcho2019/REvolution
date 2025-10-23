module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    result = 0;
    odd = A;

    for (int i = 15; i >= 8; i--) begin
        if (odd[15:8] >= B) begin
            result = result | (1 << (i - 8));
            odd = {odd[7:0], 8'd0} - (B << (i - 8));
        end else begin
            odd = {odd[7:0], 1'b0};
        end
    end

    for (int i = 7; i >= 0; i--) begin
        if (odd[15:8] >= B) begin
            result = result | (1 << i);
            odd = {odd[7:0], 8'd0} - (B << i);
        end else begin
            odd = {odd[7:0], 1'b0};
        end
    end

    odd = {8'd0, odd[7:0]};
end

endmodule