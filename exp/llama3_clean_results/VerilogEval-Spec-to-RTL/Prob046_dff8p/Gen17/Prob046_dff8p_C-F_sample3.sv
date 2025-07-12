// Define a parameterized 8-bit D flip-flop module with active high synchronous reset
module DFF_8bit #(parameter RESET_VALUE = 8'h34)( 
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

// Using always_ff for better timing performance and synthesis
always_ff @(negedge clk) begin
    if (reset) begin
        q_reg <= RESET_VALUE;
    end else begin
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

// Instantiate the 8-bit DFF with the specified reset value
DFF_8bit #(.RESET_VALUE(8'h34)) u_dff_8bit(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule