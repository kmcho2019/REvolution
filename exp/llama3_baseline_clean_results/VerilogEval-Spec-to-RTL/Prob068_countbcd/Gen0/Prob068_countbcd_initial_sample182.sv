module TopModule(
    input  clk,      // clock
    input  reset,   // synchronous active-high reset
    output [2:0] ena, // enable signals for upper three digits
    output [15:0] q  // 4-digit BCD counter output
);

reg [3:0] ones;  // ones digit
reg [3:0] tens;  // tens digit
reg [3:0] hundreds;  // hundreds digit
reg [3:0] thousands;  // thousands digit

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

always @(posedge clk) begin
    if (reset) begin  // synchronous reset
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
        ena[0] <= 0;  // initialize enable signals
        ena[1] <= 0;
        ena[2] <= 0;
    end else begin
        if (ones == 9) begin  // wrap around ones digit
            ones <= 0;
            ena[0] <= 1;  // enable tens digit increment
        end else begin
            ones <= ones + 1;
            ena[0] <= 0;
        end

        if (tens == 9 && ones == 0) begin  // wrap around tens digit
            tens <= 0;
            ena[1] <= 1;  // enable hundreds digit increment
        end else if (ones == 0 && ena[0] == 1) begin
            tens <= tens + 1;
            ena[1] <= 0;
        end else begin
            ena[1] <= 0;
        end

        if (hundreds == 9 && tens == 0 && ones == 0) begin  // wrap around hundreds digit
            hundreds <= 0;
            ena[2] <= 1;  // enable thousands digit increment
        end else if (ones == 0 && ena[0] == 1 && tens == 0 && ena[1] == 1) begin
            hundreds <= hundreds + 1;
            ena[2] <= 0;
        end else begin
            ena[2] <= 0;
        end

        if (thousands == 9 && hundreds == 0 && tens == 0 && ones == 0) begin  // wrap around thousands digit
            thousands <= 0;
        end else if (ones == 0 && ena[0] == 1 && tens == 0 && ena[1] == 1 && hundreds == 0 && ena[2] == 1) begin
            thousands <= thousands + 1;
        end
    end
end

endmodule