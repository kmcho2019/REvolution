// Wide D Flip-Flop Module with Active-Low Synchronous Reset
module WideDFF(
    input clk,
    input resetn,
    input [3:0] d,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 4'b0;
    end else begin
        q <= d;
    end
end

endmodule

// TopModule with Wide D Flip-Flop Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;

WideDFF wide_dff(clk, resetn, {q[2:0], in}, q);

assign out = q[3];

endmodule