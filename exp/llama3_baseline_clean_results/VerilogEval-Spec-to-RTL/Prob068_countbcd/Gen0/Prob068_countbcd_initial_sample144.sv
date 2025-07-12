module TopModule(
    input       clk,
    input       reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

always @(posedge clk) begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
    end else begin
        reg [3:0] next_ones;
        reg [3:0] next_tens;
        reg [3:0] next_hundreds;
        reg [3:0] next_thousands;

        next_ones = ones + 1;
        if (next_ones > 9) begin
            next_ones = 0;
        end else begin
            next_tens = tens;
            next_hundreds = hundreds;
            next_thousands = thousands;
        end

        if (next_ones == 0 && ones == 9) begin
            next_tens = tens + 1;
            if (next_tens > 9) begin
                next_tens = 0;
            end else begin
                next_hundreds = hundreds;
                next_thousands = thousands;
            end
        end

        if (next_tens == 0 && tens == 9) begin
            next_hundreds = hundreds + 1;
            if (next_hundreds > 9) begin
                next_hundreds = 0;
            end else begin
                next_thousands = thousands;
            end
        end

        if (next_hundreds == 0 && hundreds == 9) begin
            next_thousands = thousands + 1;
            if (next_thousands > 9) begin
                next_thousands = 0;
            end
        end

        ones <= next_ones;
        tens <= next_tens;
        hundreds <= next_hundreds;
        thousands <= next_thousands;
    end
end

assign ena[0] = (ones == 9) ? 1'b1 : 1'b0;
assign ena[1] = (tens == 9 && ones == 0) ? 1'b1 : 1'b0;
assign ena[2] = (hundreds == 9 && tens == 0 && ones == 0) ? 1'b1 : 1'b0;

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

endmodule