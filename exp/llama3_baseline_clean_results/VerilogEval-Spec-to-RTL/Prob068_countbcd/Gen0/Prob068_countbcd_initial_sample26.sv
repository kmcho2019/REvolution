module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] digit1;
reg [3:0] digit2;
reg [3:0] digit3;
reg [3:0] digit4;

always @(posedge clk) begin
    if (reset) begin
        digit1 <= 0;
        digit2 <= 0;
        digit3 <= 0;
        digit4 <= 0;
    end else begin
        if (digit1 == 4'd9) begin
            digit1 <= 0;
            if (digit2 == 4'd9) begin
                digit2 <= 0;
                if (digit3 == 4'd9) begin
                    digit3 <= 0;
                    digit4 <= digit4 + 1;
                end else begin
                    digit3 <= digit3 + 1;
                end
            end else begin
                digit2 <= digit2 + 1;
            end
        end else begin
            digit1 <= digit1 + 1;
        end
    end
end

assign ena[0] = (digit1 == 4'd9) && (digit2 != 4'd9);
assign ena[1] = (digit2 == 4'd9) && (digit3 != 4'd9);
assign ena[2] = (digit3 == 4'd9);

assign q[3:0] = digit1;
assign q[7:4] = digit2;
assign q[11:8] = digit3;
assign q[15:12] = digit4;

endmodule