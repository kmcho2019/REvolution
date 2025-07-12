module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg q_pos;
    reg q_neg;

    // Positive-edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative-edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    wire mux_out = clk ? q_pos : q_neg;

    // Register output on positive edge to reduce glitches and improve timing
    always @(posedge clk) begin
        q <= mux_out;
    end

endmodule