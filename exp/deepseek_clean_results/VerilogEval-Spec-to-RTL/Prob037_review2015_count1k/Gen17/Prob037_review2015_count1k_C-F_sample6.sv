module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire terminal_count = (q == 10'd999);

always @(posedge clk) begin
    if (reset) begin
        q <= 10'b0;
    end
    else begin
        q <= terminal_count ? 10'b0 : q + 1'b1;
    end
end

endmodule