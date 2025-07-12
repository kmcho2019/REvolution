module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk)
    count <= reset ? 0 : count + (up_down ? 1 : -1);

endmodule