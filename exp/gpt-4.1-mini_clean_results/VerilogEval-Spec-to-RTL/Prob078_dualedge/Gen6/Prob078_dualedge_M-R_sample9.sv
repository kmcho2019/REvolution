module TopModule (
    input wire clk,
    input wire d,
    output wire q
);

    reg q_posedge;
    reg q_negedge;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q_negedge <= d;
    end

    // Output selects between positive and negative edge samples based on clock level
    assign q = clk ? q_posedge : q_negedge;

endmodule