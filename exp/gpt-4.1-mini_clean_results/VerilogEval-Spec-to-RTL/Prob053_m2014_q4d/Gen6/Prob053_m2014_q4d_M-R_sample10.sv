module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_val;

    // Combinational XOR of input and current output
    assign xor_val = in ^ out;

    // Flip-flop updates output with the XOR on rising edge of clk
    always @(posedge clk) begin
        out <= xor_val;
    end

endmodule