module EdgeFFPos (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) q <= d;
endmodule

module EdgeFFNeg (
    input clk,
    input d,
    output reg q
);
    always @(negedge clk) q <= d;
endmodule

module TopModule (
    input clk,
    input d,
    output q
);
    wire q_pos, q_neg;

    EdgeFFPos u_pos (.clk(clk), .d(d), .q(q_pos));
    EdgeFFNeg u_neg (.clk(clk), .d(d), .q(q_neg));

    // Select output based on clock level with combinational mux
    assign q = clk ? q_pos : q_neg;
endmodule