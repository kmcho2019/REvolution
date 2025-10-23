module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

assign next_q = reset ? 4'b0001 : 
                (q == 4'b1010) ? 4'b0001 : 
                q + 4'b0001;

always @(posedge clk) begin
    q <= next_q;
end

endmodule