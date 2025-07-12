module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

wire [3:0] next_q;

assign next_q = reset ? START :        // Synchronous reset
               (q == END) ? START :   // Wrap-around at END
               q + 4'b0001;           // Normal increment

always @(posedge clk) begin
    q <= next_q;
end

endmodule