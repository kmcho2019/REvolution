module TopModule (
    input clk,
    input d,
    output q
);

    // Storage elements for both clock edges
    reg q_pos;  // Positive edge triggered flip-flop
    reg q_neg;  // Negative edge triggered flip-flop

    // Capture data on positive clock edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture data on negative clock edge
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output selection using clock as mux select
    // This is the most efficient implementation
    assign q = clk ? q_pos : q_neg;

endmodule