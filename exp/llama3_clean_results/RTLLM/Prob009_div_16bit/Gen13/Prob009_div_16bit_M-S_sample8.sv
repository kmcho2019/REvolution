module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    result = 0;
    odd = 0;

    for (int i = 15; i >= 0; i--) begin
        odd = {odd[7:0], A[i]};
        if (odd[15:8] >= B) begin
            result = result | (1 << i);
            odd = odd - {8'd0, B};
        end
    end

    odd = {8'd0, odd[7:0]};
end

endmodule