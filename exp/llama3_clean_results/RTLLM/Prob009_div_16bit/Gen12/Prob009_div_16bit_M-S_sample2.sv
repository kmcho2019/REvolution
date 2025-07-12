module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

always @(*) begin
    if (B == 8'd0) begin
        result = 16'd0;
        odd = A;
    end else begin
        result = 16'd0;
        odd = A;
        for (int i = 15; i >= 0; i--) begin
            if (odd >= {8'd0, B}) begin
                result[i] = 1'b1;
                odd = odd - {8'd0, B};
            end
            odd = odd << 1;
        end
        result = result;
        odd = odd >> 8;
    end
end

endmodule