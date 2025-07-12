module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input up_down,
    output reg [WIDTH-1:0] count
);

// Clock gating control
wire count_enable = ~reset & (up_down | (|count)); // Only count when needed

// Direction control
wire [WIDTH-1:0] next_value = up_down ? count + 1'b1 : count - 1'b1;

// Note: Natural wrap-around behavior maintained
// (2^WIDTH-1) + 1 = 0 (via WIDTH-bit overflow)
// 0 - 1 = (2^WIDTH-1) (via WIDTH-bit underflow)

always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end else if (count_enable) begin
        count <= next_value;
    end
end

endmodule