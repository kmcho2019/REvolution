module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

wire [3:0] next_q = reset ? START : (q == END) ? START : q + 1'b1;

always @(posedge clk) begin
    q <= next_q;
end

endmodule