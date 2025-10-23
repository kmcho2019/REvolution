module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output reg [15:0]  count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        if (up_down)
            count <= count + 16'd1;
        else
            count <= count - 16'd1;
    end
end

endmodule