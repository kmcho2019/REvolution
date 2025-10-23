module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q = (q == 4'd9) ? 4'd0 : q + 1'd1;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else begin
        q <= next_q;
    end
end

endmodule