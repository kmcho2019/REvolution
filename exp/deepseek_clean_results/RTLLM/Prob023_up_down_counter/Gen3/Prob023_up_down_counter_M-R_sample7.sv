module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

parameter WIDTH = 16;
wire [WIDTH-1:0] next_count;

// Continuous assignment for increment/decrement logic
assign next_count = reset ? {WIDTH{1'b0}} : 
                   up_down ? count + 1'b1 : count - 1'b1;

// Synchronous update
always @(posedge clk) begin
    count <= next_count;
end

endmodule