// Parameterized D flip-flop with synchronous reset and clock gating
module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

reg [WIDTH-1:0] d_prev;
wire clk_enable = (d != d_prev) || reset;

always @(posedge clk) begin
    d_prev <= d;
end

always @(posedge clk) begin
    if (reset) begin
        q <= {WIDTH{1'b0}};  // Synchronous reset to zero
    end
    else if (clk_enable) begin
        q <= d;              // Update only when data changes or reset
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