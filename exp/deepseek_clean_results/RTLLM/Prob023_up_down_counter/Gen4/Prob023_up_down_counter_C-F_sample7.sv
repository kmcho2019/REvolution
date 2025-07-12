module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input enable,
    input up_down,
    output reg [WIDTH-1:0] count
);

wire [WIDTH-1:0] next_count;

// Combinational next state logic
assign next_count = up_down ? count + 1'b1 : count - 1'b1;

// Synchronous update
always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end
    else if (enable) begin
        count <= next_count;
    end
end

endmodule