module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire [3:0] next_q;

assign next_q = (reset) ? 4'b0000 : 
                (slowena) ? ((q == 4'b1001) ? 4'b0000 : q + 4'b0001) : 
                q;

always @(posedge clk) begin
    q <= next_q;
end

endmodule