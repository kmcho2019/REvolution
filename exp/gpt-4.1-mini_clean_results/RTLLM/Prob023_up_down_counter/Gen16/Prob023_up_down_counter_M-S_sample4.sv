module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output reg [15:0]  count
);

always @(posedge clk) begin
    if (reset)
        count <= 16'd0;
    else
        count <= up_down ? count + 1 : count - 1;
end

endmodule