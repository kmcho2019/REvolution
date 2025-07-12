module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input up_down,
    output reg [WIDTH-1:0] count
);

wire [WIDTH-1:0] next_count;

// Combinational next state logic
assign next_count = reset ? {WIDTH{1'b0}} : 
                   (up_down ? count + 1'b1 : count - 1'b1);

// Sequential state update
always @(posedge clk) begin
    count <= next_count;
end

endmodule