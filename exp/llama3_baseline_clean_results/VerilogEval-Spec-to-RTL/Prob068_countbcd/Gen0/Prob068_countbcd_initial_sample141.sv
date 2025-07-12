module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

assign q = {thousands, hundreds, tens, ones};
assign ena[0] = (ones == 4'd9);  // enable tens digit when ones digit overflows
assign ena[1] = (tens == 4'd9) && (ones == 4'd9);  // enable hundreds digit when tens and ones digits overflow
assign ena[2] = (hundreds == 4'd9) && (tens == 4'd9) && (ones == 4'd9);  // enable thousands digit when hundreds, tens, and ones digits overflow

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        if (ones == 4'd9) begin
            ones <= 4'd0;
            if (tens == 4'd9) begin
                tens <= 4'd0;
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    if (thousands == 4'd9) begin
                        thousands <= 4'd0;
                    end else begin
                        thousands <= thousands + 1;
                    end
                end else if (ena[1]) begin
                    hundreds <= hundreds + 1;
                end
            end else if (ena[0]) begin
                tens <= tens + 1;
            end
        end else begin
            ones <= ones + 1;
        end
    end
end

endmodule