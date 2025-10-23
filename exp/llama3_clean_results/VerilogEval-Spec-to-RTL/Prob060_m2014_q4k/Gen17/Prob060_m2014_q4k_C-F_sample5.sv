// Wide D Flip-Flop Module with Active-Low Synchronous Reset and Clock Gating
module WideDFF(
    input clk,
    input resetn,
    input enable,
    input [3:0] d,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 4'b0;
    end else if (enable) begin
        q <= d;
    end
end

endmodule

// TopModule with Wide D Flip-Flop Shift Register and Clock Gating
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;
wire enable; // Assume enable signal is always high for this example
assign enable = 1'b1;

WideDFF wide_dff(clk, resetn, enable, {q[2:0], in}, q);

assign out = q[3];

endmodule