module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk)
    q <= reset ? 5'b00001 : {q[0], q[4], q[3] ^ q[0], q[2], q[1]};

endmodule