module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg gated_clk;
wire terminal_count = &q[9:5] & q[4] & ~q[3] & ~q[2] & &q[1:0]; // 1111100111 = 999

always @(*) begin
    gated_clk = clk & (~terminal_count | reset);
end

always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        q <= 10'd0;
    end
    else begin
        if (terminal_count) begin
            q <= 10'd0;
        end
        else begin
            q <= q + 10'd1;
        end
    end
end

endmodule