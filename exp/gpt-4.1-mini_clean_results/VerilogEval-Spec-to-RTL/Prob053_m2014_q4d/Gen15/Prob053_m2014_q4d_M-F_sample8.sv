module TopModule (
    input  wire clk,
    input  wire in,
    output reg  out
);

    wire d;

    // XOR of input and current output
    assign d = in ^ out;

    // Initialize 'out' to zero for simulation only
    initial out = 1'b0;

    // Simple positive edge triggered D flip-flop
    always @(posedge clk) begin
        out <= d;
    end

endmodule