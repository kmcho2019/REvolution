module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Individual D flip-flop implementations using continuous assignment
    reg q0, q1, q2, q3, q4, q5, q6, q7;

    assign q = {q7, q6, q5, q4, q3, q2, q1, q0};

    always @(posedge clk) q0 <= reset ? 1'b0 : d[0];
    always @(posedge clk) q1 <= reset ? 1'b0 : d[1];
    always @(posedge clk) q2 <= reset ? 1'b0 : d[2];
    always @(posedge clk) q3 <= reset ? 1'b0 : d[3];
    always @(posedge clk) q4 <= reset ? 1'b0 : d[4];
    always @(posedge clk) q5 <= reset ? 1'b0 : d[5];
    always @(posedge clk) q6 <= reset ? 1'b0 : d[6];
    always @(posedge clk) q7 <= reset ? 1'b0 : d[7];

endmodule