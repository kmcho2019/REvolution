// Define a simplified D flip-flop module with active high synchronous reset
module DFF( 
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'h34;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg; // Assign output directly from register

endmodule

// TopModule remains the same, instantiating the simplified DFF
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