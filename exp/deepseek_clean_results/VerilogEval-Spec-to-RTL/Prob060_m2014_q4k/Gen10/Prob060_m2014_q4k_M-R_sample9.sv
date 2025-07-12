module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    wire d0, d1, d2, d3;
    reg q0, q1, q2, q3;

    // First stage
    assign d0 = !resetn ? 1'b0 : in;
    always @(posedge clk) q0 <= d0;

    // Second stage
    assign d1 = !resetn ? 1'b0 : q0;
    always @(posedge clk) q1 <= d1;

    // Third stage
    assign d2 = !resetn ? 1'b0 : q1;
    always @(posedge clk) q2 <= d2;

    // Fourth stage
    assign d3 = !resetn ? 1'b0 : q2;
    always @(posedge clk) q3 <= d3;

    assign out = q3;

endmodule