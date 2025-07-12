module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Individual flip-flop declarations
reg q0, q1, q2, q3, q4, q5, q6, q7;

// Flip-flops with synchronous reset
always @(posedge clk) begin
    q0 <= d[0];
    q1 <= d[1];
    q2 <= d[2];
    q3 <= d[3];
    q4 <= d[4];
    q5 <= d[5];
    q6 <= d[6];
    q7 <= d[7];
end

// Combine individual flip-flop outputs
assign q = {q7, q6, q5, q4, q3, q2, q1, q0};

endmodule