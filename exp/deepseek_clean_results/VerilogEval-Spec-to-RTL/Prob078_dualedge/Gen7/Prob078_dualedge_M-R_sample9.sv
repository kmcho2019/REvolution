module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;
    wire clk_edge;

    // Edge detection (changes on either edge)
    assign clk_edge = clk ^ q_pos ^ q_neg;  // Will pulse on any clock edge

    // Update flip-flops on their respective edges
    assign q_pos = (clk_edge && clk) ? d : q_pos;
    assign q_neg = (clk_edge && ~clk) ? d : q_neg;

    // Output selection remains the same
    assign q = clk ? q_pos : q_neg;

endmodule