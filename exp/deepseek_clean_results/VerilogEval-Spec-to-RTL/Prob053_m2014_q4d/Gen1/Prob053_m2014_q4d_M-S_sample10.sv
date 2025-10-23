module TopModule (
    input clk,
    input in,
    output out
);

    reg q;  // Flip-flop state storage

    // Positive edge-triggered D flip-flop with XOR feedback
    always @(posedge clk) begin
        q <= in ^ q;
    end

    assign out = q;

endmodule