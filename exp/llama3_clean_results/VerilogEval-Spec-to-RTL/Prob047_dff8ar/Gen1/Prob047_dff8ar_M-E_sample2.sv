module DFF(
    input clk,
    input areset,
    input d,
    output reg q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 1'd0;
    end else begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

DFF dff0(clk, areset, d[0], q[0]);
DFF dff1(clk, areset, d[1], q[1]);
DFF dff2(clk, areset, d[2], q[2]);
DFF dff3(clk, areset, d[3], q[3]);
DFF dff4(clk, areset, d[4], q[4]);
DFF dff5(clk, areset, d[5], q[5]);
DFF dff6(clk, areset, d[6], q[6]);
DFF dff7(clk, areset, d[7], q[7]);

endmodule