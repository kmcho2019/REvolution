module TopModule (
    input clk,
    input in,
    output out
);

    reg q;
    wire d;

    // XOR operation between input and current output (feedback)
    assign d = in ^ q;

    // Positive edge-triggered D flip-flop
    always @(posedge clk) begin
        q <= d;
    end

    // Output assignment
    assign out = q;

endmodule