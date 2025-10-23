module TopModule (
    input  wire clk,
    input  wire in,
    output reg  out
);

    wire d;

    // XOR input with current output
    assign d = in ^ out;

    // Positive-edge triggered D flip-flop with no reset
    always @(posedge clk) begin
        out <= d;
    end

endmodule