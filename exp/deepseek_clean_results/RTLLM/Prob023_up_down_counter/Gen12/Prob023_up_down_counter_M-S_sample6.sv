module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count = 0
);

always @(posedge clk) begin
    if (reset)
        count <= 16'b0;
    else if (up_down)
        count <= count + 1;
    else
        count <= count - 1;
end

endmodule