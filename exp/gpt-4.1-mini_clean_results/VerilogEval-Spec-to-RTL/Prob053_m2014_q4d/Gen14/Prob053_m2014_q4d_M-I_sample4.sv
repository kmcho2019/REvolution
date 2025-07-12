module TopModule (
    input  wire clk,
    input  wire in,
    output reg  out
);

    wire d;
    wire update_enable;

    // Combinational XOR logic
    assign d = in ^ out;

    // Clock enable: update only if output would change
    assign update_enable = (d != out);

    // Initialize 'out' to zero for simulation (ignored by synthesis)
    initial out = 1'b0;

    // Positive-edge triggered D flip-flop with clock enable
    always @(posedge clk) begin
        if (update_enable) begin
            out <= d;
        end
    end

endmodule