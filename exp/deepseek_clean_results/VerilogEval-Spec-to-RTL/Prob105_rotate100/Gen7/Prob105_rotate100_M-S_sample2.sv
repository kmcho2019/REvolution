module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

always @(posedge clk) begin
    q <= load ? data :
         (ena == 2'b01) ? {q[0], q[99:1]} :  // right rotate
         (ena == 2'b10) ? {q[98:0], q[99]} :  // left rotate
         q;                                   // no rotate
end

endmodule