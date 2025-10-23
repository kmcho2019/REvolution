module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Efficient delta selection for +1/-1 operation
wire [15:0] delta = {16{up_down}} ^ 16'hFFFF; // 0x0001 when up, 0xFFFF when down

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        // Single adder implementation with carry ripple
        count <= count + delta;
    end
end

endmodule