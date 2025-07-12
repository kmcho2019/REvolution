module TopModule (
    input        clk,
    input  [7:0] d,
    output reg [7:0] q
);

    // Instantiate 8 individual D flip-flops using separate always blocks
    always @(posedge clk) q[0] <= d[0];
    always @(posedge clk) q[1] <= d[1];
    always @(posedge clk) q[2] <= d[2];
    always @(posedge clk) q[3] <= d[3];
    always @(posedge clk) q[4] <= d[4];
    always @(posedge clk) q[5] <= d[5];
    always @(posedge clk) q[6] <= d[6];
    always @(posedge clk) q[7] <= d[7];

endmodule