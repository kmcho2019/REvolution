module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (reset) begin
        next_q = 4'd0; // reset the counter to 0 when reset is high
    end else if (q == 4'd15) begin
        next_q = 4'd0; // wrap around to 0 when counter reaches 15
    end else begin
        next_q = q + 1; // increment the counter by 1
    end
end

always @(posedge clk) begin
    q <= next_q; // update the current state on the positive edge of the clock
end

endmodule