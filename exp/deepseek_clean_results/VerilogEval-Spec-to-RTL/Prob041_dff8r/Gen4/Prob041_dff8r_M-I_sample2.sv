module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] d_prev;
wire clock_enable = (d != d_prev) || reset;

always @(posedge clk) begin
    d_prev <= d;
end

always @(posedge clk) begin
    if (!clock_enable) begin
        q <= q;  // Hold previous value when not enabled
    end else if (reset) begin
        q <= 8'b0;
    end else begin
        q <= d;
    end
end

endmodule