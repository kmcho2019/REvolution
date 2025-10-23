module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    always @(posedge clk)
        q <= reset ? 32'h1 : (q[0] ? (q >> 1) ^ 32'h80200003 : q >> 1);
endmodule