module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire [3:0] next_q = reset ? 4'b0000 : 
                   (slowena ? ((q[3] & q[0]) ? 4'b0000 : q + 1'b1) : q;

always @(posedge clk) begin
    q <= next_q;
end

endmodule