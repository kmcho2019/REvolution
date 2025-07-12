module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset)
        count <= 16'b0;
    else
        count <= up_down ? count + 1'b1 : count - 1'b1;
end

endmodule