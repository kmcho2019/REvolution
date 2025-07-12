// Define a D flip-flop module with active high synchronous reset
module DFF( 
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(negedge clk) begin
    if (reset) q <= 8'h34; // Reset to 0x34 on reset high
    else q <= d; // Load input on reset low
end

endmodule

// TopModule instantiates a single DFF to create an 8-bit register
module TopModule( 
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

DFF u_dff( 
   .clk(clk),
   .reset(reset),
   .d(d),
   .q(q)
);

endmodule