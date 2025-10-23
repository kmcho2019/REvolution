module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset)
        count <= 0;
    else
        count <= count + (up_down ? 16'd1 : -16'd1);
end

endmodule