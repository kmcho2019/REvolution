// Parameterized D flip-flop with synchronous reset
module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (reset) q <= {WIDTH{1'b0}};  // Synchronous reset to zero
    else q <= d;                    // Normal operation
end

endmodule

// Top module with 8-bit register
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate parameterized D flip-flop with width 8
DFF #(.WIDTH(8)) dff_inst (
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule