// Define a single 8-bit D flip-flop module with active high synchronous reset
module DFF_8bit(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

parameter RESET_VALUE = 8'h34; // Reset value

reg [7:0] q_reg;

// Using a clock enable to potentially improve power efficiency
reg clk_enable;

always @(*) begin
    clk_enable = ~reset; // Clock enable is active when reset is inactive
end

always @(negedge clk) begin
    if (reset) begin
        q_reg <= RESET_VALUE;
    end else if (clk_enable) begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

// TopModule instantiates the 8-bit DFF
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate the 8-bit DFF
DFF_8bit u_dff_8bit(
   .clk(clk),
   .reset(reset),
   .d(d),
   .q(q)
);

endmodule