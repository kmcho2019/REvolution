module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_rising;  // Output of the rising edge flip-flop
reg q_falling; // Output of the falling edge flip-flop

always @(posedge clk) begin
    q_rising <= d;
end

always @(negedge clk) begin
    q_falling <= d;
end

always @(posedge clk or negedge clk) begin
    if(clk) begin
        q <= q_rising;
    end else begin
        q <= q_falling;
    end
end

endmodule