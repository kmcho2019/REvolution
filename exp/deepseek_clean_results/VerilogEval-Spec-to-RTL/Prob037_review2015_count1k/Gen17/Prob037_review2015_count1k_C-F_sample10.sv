module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

parameter MAX_COUNT = 10'd999;

// Optimized terminal count detection
wire terminal_count = (q == MAX_COUNT);
wire [9:0] next_q = reset ? 10'b0 : 
                   (terminal_count ? 10'b0 : q + 1'b1);

always @(posedge clk) begin
    q <= next_q;
end

endmodule