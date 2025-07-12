module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [13:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 14'd0;
    end else begin
        count <= (count == 14'd9999) ? 14'd0 : count + 1;
    end
end

wire [3:0] ones = count[3:0];
wire [3:0] tens = count[7:4];
wire [3:0] hundreds = count[11:8];
wire [3:0] thousands = count[13:12];

assign q = {thousands, hundreds, tens, ones};

assign ena[0] = (ones == 4'd9) && (count != 14'd9999);
assign ena[1] = (tens == 4'd9) && (count != 14'd9999);
assign ena[2] = (hundreds == 4'd9) && (count != 14'd9999);

endmodule