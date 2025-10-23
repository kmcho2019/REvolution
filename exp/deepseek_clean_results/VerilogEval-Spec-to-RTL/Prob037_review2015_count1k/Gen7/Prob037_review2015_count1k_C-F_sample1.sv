module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire terminal_count = (q[9:6] == 4'b1111) && (q[3:0] == 4'b0111);  // 999 = 1111100111

always @(posedge clk) begin
    if (reset) begin
        q <= 10'd0;
    end else if (terminal_count) begin
        q <= 10'd0;
    end else begin
        q <= q + 1'b1;
    end
end

endmodule