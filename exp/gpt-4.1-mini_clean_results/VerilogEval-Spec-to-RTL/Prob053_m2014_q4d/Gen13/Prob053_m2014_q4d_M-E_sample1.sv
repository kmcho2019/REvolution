module TopModule (
    input  wire clk,
    input  wire in,
    output reg  out
);

    wire d;

    // Combinational XOR logic
    assign d = in ^ out;

    // Positive-edge triggered D flip-flop without reset
    always @(posedge clk) begin
        out <= d;
    end

endmodule