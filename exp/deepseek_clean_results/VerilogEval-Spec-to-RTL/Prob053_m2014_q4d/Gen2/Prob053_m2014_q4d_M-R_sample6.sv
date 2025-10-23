module TopModule (
    input clk,
    input in,
    output out
);

    reg q;  // Flip-flop state storage

    // Positive edge-triggered D flip-flop with direct XOR input
    always @(posedge clk) begin
        q <= in ^ q;
    end

    // Continuous output assignment
    assign out = q;

endmodule