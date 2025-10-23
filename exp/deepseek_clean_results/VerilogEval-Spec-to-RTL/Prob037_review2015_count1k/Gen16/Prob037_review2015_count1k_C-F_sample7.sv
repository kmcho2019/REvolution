module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

// Simple and efficient terminal count detection
wire terminal_count = (q == 10'd999);

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