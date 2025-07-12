module TopModule (
    input clk,
    input in,
    output out
);

    reg q;  // The flip-flop state

    // XOR gate combining input and current output
    wire d = in ^ q;

    // Positive edge-triggered D flip-flop
    always @(posedge clk) begin
        q <= d;
    end

    assign out = q;

endmodule