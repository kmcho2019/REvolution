module TopModule(
    input clk,
    input d,
    output reg q
);

reg trigger_rising = 1'b0;
reg trigger_falling = 1'b0;

always @(posedge clk) begin
    trigger_rising <= 1'b1;
end

always @(negedge clk) begin
    trigger_falling <= 1'b1;
end

always @(posedge trigger_rising or posedge trigger_falling) begin
    if (trigger_rising) begin
        trigger_rising <= 1'b0;
    end
    if (trigger_falling) begin
        trigger_falling <= 1'b0;
    end
    q <= d;
end

endmodule