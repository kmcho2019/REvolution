module TopModule(
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

assign q = {thousands, hundreds, tens, ones};
assign ena[0] = (ones == 4'd9); // Enable tens when ones reaches 9
assign ena[1] = (tens == 4'd9) && (ones == 4'd9); // Enable hundreds when tens and ones reach 9
assign ena[2] = (hundreds == 4'd9) && (tens == 4'd9) && (ones == 4'd9); // Enable thousands when hundreds, tens, and ones reach 9

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        if (ena[0]) begin
            ones <= 4'd0;
            if (ena[1]) begin
                tens <= 4'd0;
                if (ena[2]) begin
                    hundreds <= 4'd0;
                    thousands <= thousands + 1;
                end else begin
                    hundreds <= hundreds + 1;
                end
            end else begin
                tens <= tens + 1;
            end
        end else begin
            ones <= ones + 1;
        end
    end
end

endmodule