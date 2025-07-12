module BCDCounter(
    input clk,
    input reset,
    output reg [3:0] q,
    output reg ena
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        ena <= 0;
    end else if (count == 9) begin
        count <= 0;
        ena <= 1;
    end else begin
        count <= count + 1;
        ena <= 0;
    end
end

assign q = count;

endmodule

module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;
reg ena_ones;
reg ena_tens;
reg ena_hundreds;

BCDCounter u_ones(clk, reset, ones, ena_ones);
BCDCounter u_tens(clk, reset, tens, ena_tens);
BCDCounter u_hundreds(clk, reset, hundreds, ena_hundreds);
BCDCounter u_thousands(clk, reset, thousands, ena);

always @(posedge clk) begin
    if (reset) begin
        ena_ones <= 0;
        ena_tens <= 0;
        ena_hundreds <= 0;
    end else begin
        ena_ones <= (ones == 9) ? 1 : 0;
        ena_tens <= (tens == 9 && ones == 9) ? 1 : 0;
        ena_hundreds <= (hundreds == 9 && tens == 9 && ones == 9) ? 1 : 0;
    end
end

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;
assign ena[0] = ena_ones;
assign ena[1] = ena_tens;
assign ena[2] = ena_hundreds;

endmodule