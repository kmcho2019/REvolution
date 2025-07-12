module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

// Internal wires for the count values
wire [3:0] ones, tens, hundreds, thousands;

// Internal wires for the enable signals
wire ena_ones, ena_tens, ena_hundreds, ena_thousands;

// The ones place counter is always enabled
assign ena_ones = 1'b1;

// Enable signals for upper digits
assign ena_tens = (ones == 4'd9) ? 1'b1 : 1'b0;
assign ena_hundreds = (tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0;
assign ena_thousands = (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0;

// Output assign for enable signals (3 bits)
assign ena = {ena_thousands, ena_hundreds, ena_tens};

// Output assign for count values (16 bits)
assign q = {thousands, hundreds, tens, ones};

// Instantiate the counters for each digit
Counter4Bit counter_ones(clk, reset, ena_ones, ones);
Counter4Bit counter_tens(clk, reset, ena_tens, tens);
Counter4Bit counter_hundreds(clk, reset, ena_hundreds, hundreds);
Counter4Bit counter_thousands(clk, reset, ena_thousands, thousands);

endmodule

// 4-bit counter module
module Counter4Bit(
    input clk,
    input reset,
    input ena,
    output [3:0] q
);

reg [3:0] q;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (ena) begin
        if (q == 4'd9) begin
            q <= 4'd0;
        end else begin
            q <= q + 1;
        end
    end
end

endmodule