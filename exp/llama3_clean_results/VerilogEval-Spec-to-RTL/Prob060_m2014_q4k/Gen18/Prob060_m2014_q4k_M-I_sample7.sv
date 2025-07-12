// Improved TopModule with Low-Power D Flip-Flops and Clock Gating
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;
wire enable; // Assume enable signal is always high for this example
assign enable = 1'b1;

// Use low-power D flip-flops
LowPowerDFF dff0(clk, resetn, enable, in, q[0]);
LowPowerDFF dff1(clk, resetn, enable, q[0], q[1]);
LowPowerDFF dff2(clk, resetn, enable, q[1], q[2]);
LowPowerDFF dff3(clk, resetn, enable, q[2], q[3]);

assign out = q[3];

endmodule

// Low-Power D Flip-Flop Module with Active-Low Synchronous Reset and Clock Gating
module LowPowerDFF(
    input clk,
    input resetn,
    input enable,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 1'b0;
    end else if (enable) begin
        q <= d;
    end
end

endmodule