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
assign ena[0] = (tens == 9) && (ones == 9); // enable hundreds when tens and ones reach 99
assign ena[1] = (hundreds == 9) && (tens == 9) && (ones == 9); // enable thousands when hundreds, tens, and ones reach 999
assign ena[2] = (thousands == 9) && (hundreds == 9) && (tens == 9) && (ones == 9); // enable nothing when thousands reach 9999

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
    end else begin
        if (ones < 9) begin
            ones <= ones + 1;
        end else begin
            ones <= 0;
            if (tens < 9) begin
                tens <= tens + 1;
            end else begin
                tens <= 0;
                if (hundreds < 9) begin
                    hundreds <= hundreds + 1;
                end else begin
                    hundreds <= 0;
                    if (thousands < 9) begin
                        thousands <= thousands + 1;
                    end else begin
                        thousands <= 0;
                    end
                end
            end
        end
    end
end

endmodule