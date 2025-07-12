module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos;
    reg q_neg;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered flip-flop implemented using posedge clk of inverted clk
    // We can create an inverted clock internally and use a posedge-triggered block.
    // However, Verilog does not allow posedge of an expression, so we implement negedge by 
    // using an always @(negedge clk) block since it is legal inside a single module.

    always @(negedge clk) begin
        q_neg <= d;
    end

    // Registered mux output to avoid glitches:
    // On posedge clk, latch the mux output selecting q_pos or q_neg according to clk level.
    // Because this uses posedge clk only, the output q updates synchronously.

    always @(posedge clk) begin
        q <= clk ? q_pos : q_neg;
    end

endmodule