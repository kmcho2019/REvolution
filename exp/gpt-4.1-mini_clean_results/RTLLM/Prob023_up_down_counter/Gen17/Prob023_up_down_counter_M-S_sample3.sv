module up_down_counter(
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output reg [15:0]  count
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