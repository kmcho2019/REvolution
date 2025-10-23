module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'd0;
    end else begin
        state <= (state + 1) % 8;
    end
end

assign out = (1 << state);

endmodule