module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

parameter COUNTER_WIDTH = 10;
parameter MAX_COUNT = 10'd999;

always @(posedge clk) begin
    if (reset) begin
        q <= {COUNTER_WIDTH{1'b0}};
    end else if (q == MAX_COUNT) begin
        q <= {COUNTER_WIDTH{1'b0}};
    end else begin
        q <= q + 1'b1;
    end
end

endmodule