module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] result_reg;
reg [15:0] odd_reg;
reg [7:0] remainder;
reg [7:0] temp;
reg start;
reg [3:0] count;

always @(*) begin
    if (start) begin
        if (count == 0) begin
            remainder = A[15:8];
            temp = B;
        end else if (count < 8) begin
            if (remainder >= temp) begin
                result_reg[15 - count] = 1;
                remainder = remainder - temp;
            end
            temp = temp << 1;
            remainder = {remainder[6:0], A[7 - count]};
        end else if (count == 8) begin
            odd_reg = {8'd0, remainder};
            result = result_reg;
            odd = odd_reg;
        end
        count = count + 1;
    end else begin
        count = 0;
        result_reg = 0;
        odd_reg = 0;
        remainder = 0;
        temp = 0;
    end
end

always @(posedge start) begin
    start <= 1'b1;
end

always @(negedge start) begin
    start <= 1'b0;
end

endmodule