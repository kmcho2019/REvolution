module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

parameter MAX_COUNT = 10'd999;
parameter COUNTER_WIDTH = 10;

reg wrap;

// Pre-compute wrap signal to break critical path
always @(*) begin
    wrap = (q == MAX_COUNT);
end

// Main counter with clock gating optimization
always @(posedge clk) begin
    if (reset) begin
        q <= {COUNTER_WIDTH{1'b0}};
    end else if (!wrap) begin  // Clock gating effect
        q <= q + 1'b1;
    end else begin
        q <= {COUNTER_WIDTH{1'b0}};
    end
end

endmodule