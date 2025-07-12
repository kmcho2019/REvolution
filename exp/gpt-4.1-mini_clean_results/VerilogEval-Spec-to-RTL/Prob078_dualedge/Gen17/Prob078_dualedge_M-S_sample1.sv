module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);

    reg q_pos, q_neg;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output mux selecting q_pos when clk=1, q_neg when clk=0
    assign q = clk ? q_pos : q_neg;

endmodule