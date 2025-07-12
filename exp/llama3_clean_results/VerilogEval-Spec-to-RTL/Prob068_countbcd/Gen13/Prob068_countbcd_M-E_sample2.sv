module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= count + 1;
    end
end

// BCD conversion logic
wire [3:0] ones = count[3:0];
wire [3:0] tens = count[7:4];
wire [3:0] hundreds = count[11:8];
wire [3:0] thousands = count[15:12];

// assign outputs
assign q = {thousands, hundreds, tens, ones};

// enable signals
assign ena[0] = (ones == 4'd9);
assign ena[1] = (tens == 4'd9) && (ones == 4'd0);
assign ena[2] = (hundreds == 4'd9) && (tens == 4'd0) && (ones == 4'd0);

endmodule