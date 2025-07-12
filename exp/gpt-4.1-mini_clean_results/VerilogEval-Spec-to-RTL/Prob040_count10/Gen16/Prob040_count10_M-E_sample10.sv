module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg reached_ten;

wire at_ten = (q == 4'd10);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
        reached_ten <= 1'b0;
    end else begin
        if (reached_ten) begin
            q <= 4'd0;
            reached_ten <= 1'b0;
        end else begin
            q <= q + 4'd1;
            reached_ten <= at_ten;
        end
    end
end

endmodule