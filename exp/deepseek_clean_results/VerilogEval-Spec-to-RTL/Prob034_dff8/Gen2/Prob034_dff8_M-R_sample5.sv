module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    // Declare individual flip-flop outputs
    reg q0, q1, q2, q3, q4, q5, q6, q7;

    // Instantiate 8 D flip-flops
    always @(posedge clk) q0 <= d[0];
    always @(posedge clk) q1 <= d[1];
    always @(posedge clk) q2 <= d[2];
    always @(posedge clk) q3 <= d[3];
    always @(posedge clk) q4 <= d[4];
    always @(posedge clk) q5 <= d[5];
    always @(posedge clk) q6 <= d[6];
    always @(posedge clk) q7 <= d[7];

    // Combine individual flip-flop outputs into the bus
    assign q = {q7, q6, q5, q4, q3, q2, q1, q0};

endmodule