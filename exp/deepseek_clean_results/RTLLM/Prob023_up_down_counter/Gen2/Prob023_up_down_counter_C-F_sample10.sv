module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

wire [15:0] count_increment = up_down ? 16'b1 : -16'b1;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        count <= count + count_increment;
    end
end

endmodule