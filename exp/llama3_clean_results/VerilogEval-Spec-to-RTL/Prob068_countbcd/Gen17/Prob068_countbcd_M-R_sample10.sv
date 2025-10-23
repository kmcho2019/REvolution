module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] digit0;
reg [3:0] digit1;
reg [3:0] digit2;
reg [3:0] digit3;

always @(posedge clk) begin
    if (reset) begin
        digit0 <= 4'd0;
        digit1 <= 4'd0;
        digit2 <= 4'd0;
        digit3 <= 4'd0;
    end else begin
        if (digit0 == 4'd9) begin
            digit0 <= 4'd0;
            if (digit1 == 4'd9) begin
                digit1 <= 4'd0;
                if (digit2 == 4'd9) begin
                    digit2 <= 4'd0;
                    if (digit3 == 4'd9) begin
                        digit3 <= 4'd0;
                    end else begin
                        digit3 <= digit3 + 1;
                    end
                end else begin
                    digit2 <= digit2 + 1;
                end
            end else begin
                digit1 <= digit1 + 1;
            end
        end else begin
            digit0 <= digit0 + 1;
        end
    end
end

assign q = {digit3, digit2, digit1, digit0};
assign ena[0] = (digit0 == 4'd9);
assign ena[1] = (digit1 == 4'd9) && (digit0 == 4'd9);
assign ena[2] = (digit2 == 4'd9) && (digit1 == 4'd9) && (digit0 == 4'd9);

endmodule