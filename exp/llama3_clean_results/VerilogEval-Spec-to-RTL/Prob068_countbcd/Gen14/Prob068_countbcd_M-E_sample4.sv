module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] count;
reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        count <= count + 1;
        ones <= count % 10;
        tens <= (count / 10) % 10;
        hundreds <= (count / 100) % 10;
        thousands <= count / 1000;
    end
end

assign q = {thousands, hundreds, tens, ones};

assign ena[0] = (ones == 4'd9);
assign ena[1] = (tens == 4'd9) && (ones == 4'd9);
assign ena[2] = (hundreds == 4'd9) && (tens == 4'd9) && (ones == 4'd9);

endmodule