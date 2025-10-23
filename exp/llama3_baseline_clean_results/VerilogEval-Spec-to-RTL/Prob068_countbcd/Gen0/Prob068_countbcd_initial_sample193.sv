module TopModule(
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
reg [3:0] next_ones, next_tens, next_hundreds, next_thousands;

always @(*)
begin
    next_ones = ones + 1;
    next_tens = tens;
    next_hundreds = hundreds;
    next_thousands = thousands;

    // BCD counter logic
    ena[0] = 0; // ones digit always increments
    if (ones == 9) begin
        next_ones = 0;
        ena[1] = 1; // enable tens digit to increment
        next_tens = tens + 1;
    end else begin
        ena[1] = 0;
    end

    if (tens == 9 && ones == 9) begin
        next_tens = 0;
        ena[2] = 1; // enable hundreds digit to increment
        next_hundreds = hundreds + 1;
    end else begin
        ena[2] = 0;
    end

    if (hundreds == 9 && tens == 9 && ones == 9) begin
        next_hundreds = 0;
        ena[0] = 1; // not used, but we need to set one of the enables to 1
        next_thousands = thousands + 1;
    end else begin
        ena[0] = 0;
    end

    if (thousands == 9 && hundreds == 9 && tens == 9 && ones == 9) begin
        next_thousands = 0;
        next_hundreds = 0;
        next_tens = 0;
        next_ones = 0;
    end
end

always @(posedge clk)
begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
    end else begin
        ones <= next_ones;
        tens <= next_tens;
        hundreds <= next_hundreds;
        thousands <= next_thousands;
    end
end

assign q = {thousands, hundreds, tens, ones};

endmodule