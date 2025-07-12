module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Reset value: 0x34 (binary: 00110100)
parameter RESET_VAL = 8'h34;

// Internal inverted clock for negative edge triggering
wire neg_clk;
assign neg_clk = ~clk;

// Data input mux
wire [7:0] next_q;
assign next_q = reset ? RESET_VAL : d;

// Register implementation
always @(posedge neg_clk) begin
    q <= next_q;
end

endmodule