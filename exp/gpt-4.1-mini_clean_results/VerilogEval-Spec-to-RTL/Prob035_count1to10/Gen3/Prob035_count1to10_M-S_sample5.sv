module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else begin
        count <= (count == 4'd9) ? 4'd0 : count + 4'd1;
    end
    q <= count + 4'd1;
end

endmodule