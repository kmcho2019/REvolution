// Define the refactored D flip-flop module with active high synchronous reset
module DFF( 
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

initial q = 8'h34; // Initialize q with the reset value

always @(negedge clk or posedge reset) begin
    if (reset) begin
        q <= 8'h34;
    end else begin
        q <= d;
    end
end

endmodule

// TopModule remains the same, instantiating the refactored DFF
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