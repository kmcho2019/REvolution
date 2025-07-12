// D Flip-Flop Module with Active-Low Synchronous Reset and Clock Gating
module DFF(
    input clk,
    input clk_en, // Clock enable signal
    input resetn,
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
wire clk_en; // Clock enable signal

// Clock enable logic
assign clk_en = 1'b1; // Always enable the clock for this example

DFF dff0(clk, clk_en, resetn, in, q0);
DFF dff1(clk, clk_en, resetn, q0, q1);
DFF dff2(clk, clk_en, resetn, q1, q2);
DFF dff3(clk, clk_en, resetn, q2, out);

endmodule