// Define a single D flip-flop module with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk) begin
    if (reset) begin
        q <= 1'b0; // Default reset to 0
    end else begin
        q <= d;
    end
end

endmodule

// TopModule instantiates 8 DFFs to create an 8-bit register
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Define the reset value for each DFF
wire [7:0] reset_values = 8'h34;

reg [7:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        q_reg <= reset_values;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule