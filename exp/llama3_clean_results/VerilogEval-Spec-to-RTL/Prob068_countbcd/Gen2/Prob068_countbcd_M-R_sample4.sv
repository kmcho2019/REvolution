module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

// internal signals for each digit
reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

// assign outputs
assign q = {thousands, hundreds, tens, ones};

// enable signals
assign ena[0] = (ones == 4'd9);
assign ena[1] = (tens == 4'd9) && ena[0];
assign ena[2] = (hundreds == 4'd9) && ena[1];

// sequential logic for each digit
always @(posedge clk) begin
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