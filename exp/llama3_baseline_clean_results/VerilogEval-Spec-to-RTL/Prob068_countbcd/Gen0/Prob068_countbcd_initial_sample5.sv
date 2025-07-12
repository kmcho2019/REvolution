module TopModule(
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
        ena <= 3'b000;
    end else begin
        ones <= ones + 1;
        ena[0] <= (ones == 4'd9) ? 1'b1 : 1'b0;
        if(ones == 4'd0) begin
            tens <= tens + ena[0];
            ena[1] <= (tens == 4'd9) ? 1'b1 : 1'b0;
            if(tens == 4'd0) begin
                hundreds <= hundreds + ena[1];
                ena[2] <= (hundreds == 4'd9) ? 1'b1 : 1'b0;
                if(hundreds == 4'd0) begin
                    thousands <= thousands + ena[2];
                end
            end
        end
    end
end

always @(*) begin
    q[3:0] <= ones;
    q[7:4] <= tens;
    q[11:8] <= hundreds;
    q[15:12] <= thousands;
end

endmodule