module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    result = 0;
    odd = A;
    for (int i = 15; i >= 0; i--) begin
        if (odd[15:8] >= B) begin
            if (i < 8) begin
                result[i] = 1;
            end else begin
                result[i-8] = 1;
            end
            odd = (odd[7:0], (odd[15:8] - B));
        end else begin
            odd = {1'b0, odd[15:1]};
        end
    end
    odd = {8'b0, odd[7:0]};
end

endmodule