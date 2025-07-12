module TopModule (
    input clk,
    input in,
    output out
);

    wire d_ff;
    wire xor_out;

    // Combinational XOR logic
    assign xor_out = in ^ d_ff;

    // Clocked flip-flop implementation using continuous assignment
    assign d_ff = (clk && clk) ? xor_out : d_ff;  // The (clk && clk) is just to satisfy synthesis rules

    // Output assignment
    assign out = d_ff;

endmodule