module TopModule (
    input clk,
    input in,
    output out
);

    reg q;  // Flip-flop state storage

    // Combined XOR and output assignment
    assign out = q;

    // Positive edge-triggered D flip-flop with direct XOR input
    always @(posedge clk) begin
        q <= in ^ out;  // Uses output feedback as specified
    end

endmodule