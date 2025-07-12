module JC_counter #(parameter WIDTH = 64) (
    input clk,
    input rst_n,
    output reg [WIDTH-1:0] Q
);

always @(posedge clk or negedge rst_n)
    if (!rst_n) Q <= {WIDTH{1'b0}};
    else Q <= {~Q[0], Q[WIDTH-1:1]};

endmodule