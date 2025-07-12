// Parameterized D flip-flop with synchronous reset and clock gating
module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

reg [WIDTH-1:0] prev_d;
wire clk_enable = (prev_d != d) || reset;  // Enable clock when input changes or reset
wire gated_clk = clk & clk_enable;

always @(posedge gated_clk) begin
    if (reset) begin
        q <= {WIDTH{1'b0}};  // Synchronous reset to zero
        prev_d <= {WIDTH{1'b0}};
    end
    else begin
        q <= d;             // Normal operation
        prev_d <= d;        // Store previous input
    end
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