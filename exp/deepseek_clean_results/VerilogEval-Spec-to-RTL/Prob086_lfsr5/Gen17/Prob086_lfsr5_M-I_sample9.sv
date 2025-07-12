module TopModule (
    input clk,
    input reset,
    output reg [4:0] q = 1
);

always @(posedge clk)
    q <= reset ? 1 : {q[0], q[4], q[3]^q[0], q[2:1]};

endmodule