module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

localparam MAX_COUNT = 10'd999;
localparam COUNTER_WIDTH = 10;

wire wrap = (q == MAX_COUNT);
reg [COUNTER_WIDTH-1:0] next_q;

// Combinational next-state logic
always @(*) begin
    if (wrap) begin
        next_q = {COUNTER_WIDTH{1'b0}};
    end else begin
        next_q = q + 1'b1;
    end
end

// Sequential state logic
always @(posedge clk) begin
    if (reset) begin
        q <= {COUNTER_WIDTH{1'b0}};
    end else begin
        q <= next_q;
    end
end

endmodule