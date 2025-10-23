module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

wire [15:0] delta;

assign delta = up_down ? 16'h0001 : 16'hFFFF; // +1 or -1 in 2's complement

always @(posedge clk) begin
    if (reset)
        count <= 16'd0;
    else
        count <= count + delta;
end

endmodule