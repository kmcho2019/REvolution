module TopModule (
    input  wire clk,
    input  wire in,
    output reg  out = 1'b0  // Initialized to avoid simulation X mismatch
);

    wire d;
    wire ce;

    // Combinational XOR logic
    assign d = in ^ out;

    // Clock enable: update flip-flop only if 'd' differs from current 'out'
    assign ce = (d != out);

    // Positive-edge triggered D flip-flop without reset, with clock enable
    always @(posedge clk) begin
        if (ce)
            out <= d;
    end

endmodule