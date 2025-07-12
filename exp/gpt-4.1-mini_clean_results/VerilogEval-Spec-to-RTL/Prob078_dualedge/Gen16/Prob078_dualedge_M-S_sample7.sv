module TopModule (
    input wire clk,
    input wire d,
    output wire q
);

    reg q_posedge, q_negedge;

    // Positive edge flip-flop
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Negative edge flip-flop
    always @(negedge clk) begin
        q_negedge <= d;
    end

    // Output mux selects sampled data based on clock level
    assign q = clk ? q_posedge : q_negedge;

endmodule