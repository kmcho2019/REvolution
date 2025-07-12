// Define a D flip-flop module with active high synchronous reset and clock gating
module DFF( 
    input clk,
    input reset,
    input enable, // clock enable signal
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;
reg clk_gated; // gated clock signal

always @(negedge clk) begin
    if (enable) begin
        if (reset) begin
            q_reg <= 8'h34;
        end else begin
            q_reg <= d;
        end
    end
end

assign clk_gated = clk & enable; // clock gating

// assign q = q_reg;
assign q = q_reg; // assign output directly from register

endmodule

// TopModule instantiates a single DFF to create an 8-bit register
module TopModule( 
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg enable; // clock enable signal
assign enable = 1'b1; // always enable the clock for simplicity

DFF u_dff( 
   .clk(clk),
   .reset(reset),
   .enable(enable),
   .d(d),
   .q(q)
);

endmodule