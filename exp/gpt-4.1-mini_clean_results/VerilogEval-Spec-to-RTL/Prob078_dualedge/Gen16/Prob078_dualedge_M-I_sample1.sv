module TopModule (
    input  clk,
    input  d,
    output reg q
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

    // Mux between q_pos and q_neg depending on clock level
    wire mux_out = clk ? q_pos : q_neg;

    // Register output to reduce glitches and improve timing
    always @(posedge clk) begin
        q <= mux_out;
    end

endmodule