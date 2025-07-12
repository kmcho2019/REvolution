module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    input wire clk_en,          // Clock enable input to gate counting
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset)
        count <= 16'd0;
    else if (clk_en) begin
        if (up_down)
            count <= count + 1;
        else
            count <= count - 1;
    end
end

endmodule