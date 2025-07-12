module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        count <= up_down ? count + 1'b1 : count - 1'b1;
    end
end

endmodule