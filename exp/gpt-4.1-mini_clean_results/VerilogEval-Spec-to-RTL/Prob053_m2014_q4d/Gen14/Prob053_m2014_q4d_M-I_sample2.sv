module TopModule (
    input clk,
    input in,
    output reg out
);

    // XOR gate combines input 'in' with current output 'out'
    // The output 'out' is the stored flip-flop state updated on clk rising edge
    wire xor_result;
    assign xor_result = in ^ out;

    // Positive edge triggered D flip-flop stores xor_result without reset
    always @(posedge clk) begin
        out <= xor_result;
    end

endmodule