module TopModule (
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
        if (ones == 4'd9) begin
            ones <= 4'd0;
            ena[0] <= 1'b1;
        end else begin
            ones <= ones + 1'd1;
            ena[0] <= 1'b0;
        end

        if (ena[0] && tens == 4'd9) begin
            tens <= 4'd0;
            ena[1] <= 1'b1;
        end else if (ena[0]) begin
            tens <= tens + 1'd1;
            ena[1] <= 1'b0;
        end else begin
            ena[1] <= 1'b0;
        end

        if (ena[1] && hundreds == 4'd9) begin
            hundreds <= 4'd0;
            ena[2] <= 1'b1;
        end else if (ena[1]) begin
            hundreds <= hundreds + 1'd1;
            ena[2] <= 1'b0;
        end else begin
            ena[2] <= 1'b0;
        end

        if (ena[2] && thousands == 4'd9) begin
            thousands <= 4'd0;
        end else if (ena[2]) begin
            thousands <= thousands + 1'd1;
        end
    end
end

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

endmodule