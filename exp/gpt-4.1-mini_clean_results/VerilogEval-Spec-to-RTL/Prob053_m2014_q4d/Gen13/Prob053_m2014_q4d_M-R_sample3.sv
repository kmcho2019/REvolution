module TopModule (
    input clk,
    input in,
    output reg out
);

    wire d;

    // Combinational XOR of input and current output
    assign d = in ^ out;

    // Positive edge triggered D flip-flop without reset
    always @(posedge clk) begin
        out <= d;
    end

endmodule