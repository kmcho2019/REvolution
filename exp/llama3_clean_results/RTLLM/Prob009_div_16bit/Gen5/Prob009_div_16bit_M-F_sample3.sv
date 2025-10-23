module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    if (b_reg == 0) begin
        result = 0;
        odd = a_reg;
    end else begin
        result = 0;
        odd = a_reg;
        for (int i = 15; i >= 0; i--) begin
            reg [7:0] temp;
            if (i >= 8) begin
                temp = odd[15:8];
            end else begin
                temp = {odd[15:8], 8'b0};
            end
            if (temp >= b_reg) begin
                result[15-i] = 1;
                if (i >= 8) begin
                    odd = {temp - b_reg, odd[7:0]};
                end else begin
                    odd = {8'b0, temp - b_reg};
                end
            end else begin
                if (i >= 8) begin
                    odd = {temp, odd[7:0]};
                end else begin
                    odd = {8'b0, temp};
                end
                odd = odd << 1;
            end
        end
    end
end

endmodule