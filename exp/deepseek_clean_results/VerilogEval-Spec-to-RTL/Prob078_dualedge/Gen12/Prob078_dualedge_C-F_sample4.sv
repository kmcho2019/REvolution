module TopModule (
    input clk,
    input d,
    output q
);

    // Sequential elements
    reg q_pos;  // Captures data on positive clock edge
    reg q_neg;  // Captures data on negative clock edge

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Combinational output selection
    // Selects most recently updated flip-flop based on clock state
    assign q = clk ? q_pos : q_neg;

endmodule