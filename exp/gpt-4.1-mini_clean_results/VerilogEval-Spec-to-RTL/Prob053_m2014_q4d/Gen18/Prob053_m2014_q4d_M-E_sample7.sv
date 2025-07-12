module TopModule (
    input clk,
    input in,
    output reg out
);

    wire next_out;

    // Combinational logic: XOR input with current state
    assign next_out = in ^ out;

    // Sequential logic: positive edge-triggered D flip-flop storing next_out
    always @(posedge clk) begin
        out <= next_out;
    end

endmodule