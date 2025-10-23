module TopModule (
    input  clk,
    input  d,
    output q
);

    reg q_posedge;
    reg q_negedge;

    // Positive edge triggered flip-flop behavior
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Negative edge triggered flip-flop behavior
    always @(negedge clk) begin
        q_negedge <= d;
    end

    // Output selects the sampled value corresponding to current clock level
    assign q = clk ? q_posedge : q_negedge;

endmodule