// D Flip-Flop Module with Active-Low Synchronous Reset and Clock Enable
module DFF(
    input clk,
    input resetn,
    input clk_en, // Clock enable
    input d,
    output reg q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 1'b0;
    end else if (clk_en) begin
        q <= d;
    end
end

endmodule

// TopModule with Shift Register and Clock Gating
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

wire q0, q1, q2;
wire clk_en; // Clock enable for the first flip-flop

// Simple clock gating logic for demonstration purposes
// This assumes the input data is static when 'in' is 0, which may not always be the case
assign clk_en = in;

DFF dff0(clk, resetn, clk_en, in, q0);
DFF dff1(clk, resetn, 1'b1, q0, q1); // No clock gating for subsequent flip-flops
DFF dff2(clk, resetn, 1'b1, q1, q2);
DFF dff3(clk, resetn, 1'b1, q2, out);

endmodule