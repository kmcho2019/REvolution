module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Continuous assignment for next count value
wire [15:0] next_count = up_down ? count + 1'b1 : count - 1'b1;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= next_count;
    end
end

endmodule