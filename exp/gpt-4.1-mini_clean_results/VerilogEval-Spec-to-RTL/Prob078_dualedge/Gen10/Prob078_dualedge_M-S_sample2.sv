module TopModule (
    input clk,
    input d,
    output reg q
);

    wire clk_bar = ~clk;
    reg q_ff;    // flip-flop output (pos edge sampling)
    reg q_latch; // latch output (falling edge sampling)

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_ff <= d;
    end

    // Transparent latch enabled when clk_bar=1 (i.e., clk=0)
    always @(*) begin
        if (clk_bar)
            q_latch = d;
        // else hold q_latch (inferred latch)
    end

    // Output mux selects flip-flop output when clk=1, latch output when clk=0
    always @(*) begin
        if (clk)
            q = q_ff;
        else
            q = q_latch;
    end

endmodule