module TopModule (
    input  wire clk,  // Positive edge-triggered clock
    input  wire ar,   // Asynchronous reset (active high)
    input  wire d,    // Data input
    output reg  q     // Registered output
);

// Internal signals
wire clk_delayed;
wire posedge_clk;
wire reset_mux_out;
wire d_ff_input;

// Clock edge detector
not #1 (clk_delayed, clk);
and (posedge_clk, clk, clk_delayed);

// Reset multiplexer (async reset has priority)
assign reset_mux_out = ar ? 1'b0 : d;

// DFF implementation
always @(posedge posedge_clk or posedge ar)
    if (ar) q <= 1'b0;
    else    q <= reset_mux_out;

endmodule