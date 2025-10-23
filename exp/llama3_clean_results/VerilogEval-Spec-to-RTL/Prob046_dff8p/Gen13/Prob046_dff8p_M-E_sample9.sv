// Define a custom 8-bit register module with active high synchronous reset
module CustomRegister(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'h34; // Reset value is 0x34
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

// TopModule instantiates the custom register
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate the custom register
CustomRegister reg(
   .clk(clk),
   .reset(reset),
   .d(d),
   .q(q)
);

endmodule