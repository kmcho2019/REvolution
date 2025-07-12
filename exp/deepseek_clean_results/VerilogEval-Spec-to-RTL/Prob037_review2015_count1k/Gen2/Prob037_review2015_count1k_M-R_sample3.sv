module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire [9:0] next_q;

assign next_q = (reset) ? 10'd0 : 
                (q == 10'd999) ? 10'd0 : 
                q + 10'd1;

always @(posedge clk) begin
    q <= next_q;
end

endmodule