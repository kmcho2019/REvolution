module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire count_en = (q != 4'd9);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (count_en) begin
        q <= q + 4'd1;
    end else begin
        q <= 4'd0;
    end
end

endmodule