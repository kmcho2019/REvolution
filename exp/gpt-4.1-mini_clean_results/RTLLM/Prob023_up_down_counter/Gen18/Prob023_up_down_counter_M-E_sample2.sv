module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

wire [15:0] incremented;
wire [15:0] decremented;
wire [15:0] next_count;

// Compute increment and decrement combinationally
assign incremented = count + 16'd1;
assign decremented = count - 16'd1;

// Select next_count based on up_down control signal
assign next_count = up_down ? incremented : decremented;

always @(posedge clk) begin
    if (reset)
        count <= 16'd0;
    else
        count <= next_count;
end

endmodule