module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire terminal_count = q[3] & q[0];  // Detects 9 (1001)
wire [3:0] next_q = terminal_count ? 4'b0000 : q + 1'b1;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        q <= next_q;
    end
end

endmodule