module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk)
    count <= reset ? 16'd0 : up_down ? count + 1 : count - 1;

endmodule