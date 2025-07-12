module TopModule (
    input clk,
    input in,
    output reg out
);

    wire d_input;

    assign d_input = in ^ out;  // Combinational XOR of input and flip-flop output

    always @(posedge clk)
        out <= d_input;        // Positive edge triggered flip-flop

endmodule