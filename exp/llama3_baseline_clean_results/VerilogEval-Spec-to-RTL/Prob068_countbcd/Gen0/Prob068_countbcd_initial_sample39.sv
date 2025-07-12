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

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

always @ (posedge clk) begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
    end else begin
        if (ones == 4'd9) begin
            ones <= 0;
            ena[0] <= 1'b1; // Enable tens place to increment
        end else begin
            ones <= ones + 1'b1;
            ena[0] <= 1'b0;
        end

        if (ena[0] && tens == 4'd9) begin
            tens <= 0;
            ena[1] <= 1'b1; // Enable hundreds place to increment
        end else if (ena[0]) begin
            tens <= tens + 1'b1;
            ena[1] <= 1'b0;
        end else begin
            ena[1] <= 1'b0;
        end

        if (ena[1] && hundreds == 4'd9) begin
            hundreds <= 0;
            ena[2] <= 1'b1; // Enable thousands place to increment
        end else if (ena[1]) begin
            hundreds <= hundreds + 1'b1;
            ena[2] <= 1'b0;
        end else begin
            ena[2] <= 1'b0;
        end

        if (ena[2] && thousands == 4'd9) begin
            thousands <= 0;
        end else if (ena[2]) begin
            thousands <= thousands + 1'b1;
        end
    end
end

endmodule