module TopModule (
    input clk,
    input x,
    output z
);

    wire xor_ff, and_ff, or_ff;
    wire xor_gate, and_gate, or_gate;
    reg clk_prev;

    // Initialize flip-flops to 0
    initial begin
        clk_prev = 0;
    end

    // Clock edge detection
    wire posedge_clk = clk & ~clk_prev;

    // Gate logic
    assign xor_gate = x ^ xor_ff;
    assign and_gate = x & ~and_ff;
    assign or_gate  = x | ~or_ff;

    // Flip-flops with edge-triggered behavior
    assign xor_ff = posedge_clk ? xor_gate : xor_ff;
    assign and_ff = posedge_clk ? and_gate : and_ff;
    assign or_ff  = posedge_clk ? or_gate  : or_ff;

    // Track previous clock for edge detection
    always @(clk) begin
        clk_prev <= clk;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule