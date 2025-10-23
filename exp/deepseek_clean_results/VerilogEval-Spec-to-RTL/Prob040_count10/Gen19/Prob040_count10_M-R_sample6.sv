module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q = reset ? 4'd0 : 
                   (q == 4'd9) ? 4'd0 : 
                   q + 1'd1;

always @(posedge clk) begin
    q <= next_q;
end

endmodule