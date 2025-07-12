module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        reg [3:0] new_ones;
        reg [3:0] new_tens;
        reg [3:0] new_hundreds;
        reg [3:0] new_thousands;

        new_ones = ones + 1;
        if (new_ones == 4'd10) begin
            new_ones = 4'd0;
            new_tens = tens + 1;
        end else begin
            new_tens = tens;
        end

        if (new_tens == 4'd10) begin
            new_tens = 4'd0;
            new_hundreds = hundreds + 1;
        end else begin
            new_hundreds = hundreds;
        end

        if (new_hundreds == 4'd10) begin
            new_hundreds = 4'd0;
            new_thousands = thousands + 1;
        end else begin
            new_thousands = thousands;
        end

        if (new_thousands == 4'd10) begin
            new_thousands = 4'd0;
        end

        ones <= new_ones;
        tens <= new_tens;
        hundreds <= new_hundreds;
        thousands <= new_thousands;
    end
end

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

assign ena[0] = (ones == 4'd9);
assign ena[1] = (tens == 4'd9) && (ones == 4'd9);
assign ena[2] = (hundreds == 4'd9) && (tens == 4'd9) && (ones == 4'd9);

endmodule