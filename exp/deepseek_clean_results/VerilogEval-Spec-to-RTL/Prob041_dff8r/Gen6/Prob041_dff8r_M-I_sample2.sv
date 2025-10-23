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
wire clk_en = reset || (d != d_prev);

always @(posedge clk) begin
    d_prev <= d;  // Store previous input for comparison
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= {WIDTH{1'b0}};  // Synchronous reset
        d_prev <= {WIDTH{1'b0}};
    end
    else if (clk_en) begin
        q <= d;  // Only update when inputs change or reset
    end
end

endmodule

// Top module with 8-bit register and clock gating
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