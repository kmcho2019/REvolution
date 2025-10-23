module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_out;

    // Combinational XOR of input and current output
    assign xor_out = in ^ out;

    // Initialize output to 0 for simulation to avoid unknown startup state
    initial begin
        out = 0;
    end

    // Sequential logic: D flip-flop capturing xor_out on rising edge of clk
    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule