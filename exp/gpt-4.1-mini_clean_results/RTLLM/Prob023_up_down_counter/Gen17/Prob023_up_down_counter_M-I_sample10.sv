module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output reg [15:0]  count
);

wire count_enable;

assign count_enable = (up_down && (count != 16'hFFFF)) || 
                      (~up_down && (count != 16'h0000));

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else if (count_enable) begin
        if (up_down)
            count <= count + 16'd1;
        else
            count <= count - 16'd1;
    end
end

endmodule