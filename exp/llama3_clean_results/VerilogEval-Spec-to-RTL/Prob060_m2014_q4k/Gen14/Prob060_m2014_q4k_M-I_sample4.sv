// D Flip-Flop Module with Active-Low Synchronous Reset
module DFF(
    input clk,
    input resetn,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 1'b0;
    end else begin
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
wire clk_gated;

// Clock Gating
always @(posedge clk) begin
    if (resetn) begin
        clk_gated <= in; // Enable clock only when input is high
    end else begin
        clk_gated <= 1'b0;
    end
end

DFF dff0(clk_gated, resetn, in, q0);
DFF dff1(clk_gated, resetn, q0, q1);
DFF dff2(clk_gated, resetn, q1, q2);
DFF dff3(clk_gated, resetn, q2, out);

endmodule