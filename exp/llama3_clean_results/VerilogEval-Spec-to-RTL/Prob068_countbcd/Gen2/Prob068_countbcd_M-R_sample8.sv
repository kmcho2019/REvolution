module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

// internal signals for each digit
reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

// internal enable signals
wire ena_ones;
wire ena_tens;
wire ena_hundreds;
wire ena_thousands;

// assign outputs
assign q = {thousands, hundreds, tens, ones};

// enable signals
assign ena_ones = 1'b1; // always enable the ones place
assign ena_tens = (ones == 4'd9);
assign ena_hundreds = (tens == 4'd9);
assign ena_thousands = (hundreds == 4'd9);

assign ena = {ena_thousands, ena_hundreds, ena_tens};

// sequential logic for each digit
always @(posedge clk) begin
    if (reset) begin
        // reset to 0
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        // count up
        if (ena_ones) begin
            ones <= (ones == 4'd9)? 4'd0 : ones + 1;
        end

        if (ena_tens) begin
            tens <= (tens == 4'd9)? 4'd0 : tens + 1;
        end

        if (ena_hundreds) begin
            hundreds <= (hundreds == 4'd9)? 4'd0 : hundreds + 1;
        end

        if (ena_thousands) begin
            thousands <= (thousands == 4'd9)? 4'd0 : thousands + 1;
        end
    end
end

endmodule