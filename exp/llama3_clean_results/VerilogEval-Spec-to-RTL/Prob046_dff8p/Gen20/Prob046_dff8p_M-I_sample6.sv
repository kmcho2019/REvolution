// Define an optimized D flip-flop module with active high synchronous reset
module DFF( 
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q // Directly use output as reg
);

always @(negedge clk) begin
    if (reset) begin
        q <= 8'h34; // Reset value remains as specified
    end else begin
        q <= d;
    end
end

endmodule

// TopModule remains the same, instantiating the optimized DFF
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