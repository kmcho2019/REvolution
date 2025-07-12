module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

// Clock enable: only update count on active counting cycles.
// This avoids toggling count unnecessarily, reducing power and potentially improving timing.
wire count_enable = 1'b1; // Always enabled since counter changes every clock as per spec.
// If desired, logic to disable counting when static could be added here.

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else if (count_enable) begin
        if (up_down)
            count <= count + 1;
        else
            count <= count - 1;
    end
end

endmodule