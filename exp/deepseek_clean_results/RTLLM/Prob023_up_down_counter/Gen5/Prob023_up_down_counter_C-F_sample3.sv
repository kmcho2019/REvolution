module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    count <= reset ? 16'd0 : count + (up_down ? 1'b1 : -1'b1);
end

endmodule