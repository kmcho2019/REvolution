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

// TopModule with Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;

DFF dff0(clk, resetn, in, q[0]);
DFF dff1(clk, resetn, q[0], q[1]);
DFF dff2(clk, resetn, q[1], q[2]);
DFF dff3(clk, resetn, q[2], q[3]);

assign out = q[3];

endmodule