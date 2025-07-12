module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        reg carry_ones;
        reg carry_tens;
        reg carry_hundreds;

        carry_ones = (ones == 4'd9);
        carry_tens = carry_ones && (tens == 4'd9);
        carry_hundreds = carry_tens && (hundreds == 4'd9);

        if (carry_hundreds) begin
            thousands <= thousands + 1;
            hundreds <= 4'd0;
            tens <= 4'd0;
            ones <= 4'd0;
        end else if (carry_tens) begin
            hundreds <= hundreds + 1;
            tens <= 4'd0;
            ones <= 4'd0;
        end else if (carry_ones) begin
            tens <= tens + 1;
            ones <= 4'd0;
        end else begin
            ones <= ones + 1;
        end
    end
end

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

assign ena[0] = (ones == 4'd9);
assign ena[1] = (tens == 4'd9) && (ones == 4'd9);
assign ena[2] = (hundreds == 4'd9) && (tens == 4'd9) && (ones == 4'd9);

endmodule