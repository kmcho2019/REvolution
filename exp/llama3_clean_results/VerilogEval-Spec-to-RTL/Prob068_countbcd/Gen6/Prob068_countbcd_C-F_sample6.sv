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
        reg [3:0] ones, tens, hundreds, thousands;
        reg [3:0] next_ones, next_tens, next_hundreds, next_thousands;
        
        // current count
        assign ones = count[3:0];
        assign tens = count[7:4];
        assign hundreds = count[11:8];
        assign thousands = count[15:12];

        // next count
        assign next_ones = (ones == 4'd9) ? 4'd0 : ones + 1;
        assign next_tens = (ones == 4'd9) ? (tens == 4'd9) ? 4'd0 : tens + 1 : tens;
        assign next_hundreds = (ones == 4'd9 && tens == 4'd9) ? (hundreds == 4'd9) ? 4'd0 : hundreds + 1 : hundreds;
        assign next_thousands = (ones == 4'd9 && tens == 4'd9 && hundreds == 4'd9) ? (thousands == 4'd9) ? 4'd0 : thousands + 1 : thousands;

        // update count
        count[3:0] <= next_ones;
        count[7:4] <= next_tens;
        count[11:8] <= next_hundreds;
        count[15:12] <= next_thousands;
    end
end

assign q = count;
assign ena[0] = (count[3:0] == 4'd9);
assign ena[1] = (count[7:4] == 4'd9) && (count[3:0] == 4'd9);
assign ena[2] = (count[11:8] == 4'd9) && (count[7:4] == 4'd9) && (count[3:0] == 4'd9);

endmodule