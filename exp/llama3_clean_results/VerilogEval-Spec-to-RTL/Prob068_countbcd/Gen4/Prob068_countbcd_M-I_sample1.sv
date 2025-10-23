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

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
        ena <= 3'b000;
    end else begin
        if (ones == 4'd9) begin
            ones <= 4'd0;
            tens <= tens + 1'b1;
            ena[0] <= 1'b1;
        end else begin
            ones <= ones + 1'b1;
            ena[0] <= 1'b0;
        end

        if (tens == 4'd9 && ena[0] == 1'b1) begin
            tens <= 4'd0;
            hundreds <= hundreds + 1'b1;
            ena[1] <= 1'b1;
        end else begin
            ena[1] <= 1'b0;
        end

        if (hundreds == 4'd9 && ena[1] == 1'b1) begin
            hundreds <= 4'd0;
            thousands <= thousands + 1'b1;
            ena[2] <= 1'b1;
        end else begin
            ena[2] <= 1'b0;
        end
    end
end

assign q = {thousands, hundreds, tens, ones};

endmodule