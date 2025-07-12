module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

reg [15:0] next_count;

always @(*) begin
    if (up_down)
        next_count = count + 1;
    else
        next_count = count - 1;
end

always @(posedge clk) begin
    if (reset)
        count <= 16'b0;
    else
        count <= next_count;
end

endmodule