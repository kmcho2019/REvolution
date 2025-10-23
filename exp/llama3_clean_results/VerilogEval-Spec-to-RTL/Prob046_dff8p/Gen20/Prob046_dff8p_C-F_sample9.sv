// Define a parameterized 8-bit D flip-flop module with active high synchronous reset
module DFF_8bit #(parameter RESET_VALUE = 8'h34, parameter DATA_WIDTH = 8)( 
    input clk,
    input reset,
    input [DATA_WIDTH-1:0] d,
    output [DATA_WIDTH-1:0] q
);

reg [DATA_WIDTH-1:0] q_reg;

// Using always_ff for better timing performance and synthesis
always_ff @(negedge clk) begin
    if (reset) begin
        q_reg <= RESET_VALUE;
    end else if (d !== q_reg) begin // Only update if input has changed
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

// TopModule instantiates the parameterized 8-bit DFF
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate the 8-bit DFF with the specified reset value and data width
DFF_8bit #(.RESET_VALUE(8'h34), .DATA_WIDTH(8)) u_dff_8bit(
  .clk(clk),
  .reset(reset),
  .d(d),
  .q(q)
);

endmodule