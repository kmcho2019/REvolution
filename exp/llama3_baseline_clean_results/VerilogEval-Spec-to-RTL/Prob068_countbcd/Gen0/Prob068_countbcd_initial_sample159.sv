module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones;  // ones digit
reg [3:0] tens;  // tens digit
reg [3:0] hundreds;  // hundreds digit
reg [3:0] thousands;  // thousands digit

assign q = {thousands, hundreds, tens, ones};  // concatenate digits

assign ena[0] = (ones == 4'd9);  // enable tens digit when ones digit is 9
assign ena[1] = (tens == 4'd9 && ones == 4'd9);  // enable hundreds digit when tens and ones digits are 9
assign ena[2] = (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9);  // enable thousands digit when hundreds, tens, and ones digits are 9

always @(posedge clk) begin
    if (reset) begin  // synchronous reset
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
                        thousands <= 4'd0;  // roll over to 0
                    end else begin
                        thousands <= thousands + 1;  // increment thousands digit
                    end
                end else begin
                    hundreds <= hundreds + 1;  // increment hundreds digit
                end
            end else begin
                tens <= tens + 1;  // increment tens digit
            end
        end else begin
            ones <= ones + 1;  // increment ones digit
        end
    end
end

endmodule