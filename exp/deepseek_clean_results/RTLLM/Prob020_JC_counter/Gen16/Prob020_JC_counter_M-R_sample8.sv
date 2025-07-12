module JC_counter #(parameter WIDTH = 64) (
    input clk,
    input rst_n,
    output reg [WIDTH-1:0] Q
);

wire [WIDTH-1:0] next_Q;

// Combinational next-state logic
assign next_Q = {~Q[0], Q[WIDTH-1:1]};

// Sequential state update
always @(posedge clk or negedge rst_n)
    if (!rst_n) Q <= {WIDTH{1'b0}};
    else Q <= next_Q;

endmodule