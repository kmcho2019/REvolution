module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // reset the counter to 0 when reset is high
    end else begin
        q <= q + 1; // increment the counter by 1 on every positive edge of the clock
    end
end

endmodule