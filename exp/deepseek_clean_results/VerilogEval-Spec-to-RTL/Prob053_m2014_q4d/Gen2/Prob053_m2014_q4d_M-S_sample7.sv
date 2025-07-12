module TopModule (
    input clk,
    input in,
    output reg out
);

    // Positive edge-triggered D flip-flop with XOR feedback
    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule