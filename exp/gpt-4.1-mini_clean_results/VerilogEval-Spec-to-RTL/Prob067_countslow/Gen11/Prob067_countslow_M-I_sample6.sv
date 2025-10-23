module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire [3:0] next_q;
wire wrap;

assign wrap = (q == 4'd9);
assign next_q = wrap ? 4'd0 : q + 4'd1;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (slowena) begin
        q <= next_q;
    end
    // else hold q
end

endmodule