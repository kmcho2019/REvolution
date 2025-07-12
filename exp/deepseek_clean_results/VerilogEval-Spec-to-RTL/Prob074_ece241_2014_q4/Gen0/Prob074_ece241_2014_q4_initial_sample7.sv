module TopModule (
    input clk,
    input x,
    output z
);

    // Declare wires for DFF inputs and outputs
    wire xor_out, and_out, or_out;
    wire q_xor, q_and, q_or;

    // Instantiate the three gates
    assign xor_out = x ^ q_xor;               // XOR gate with its own DFF output
    assign and_out = x & (~q_and);            // AND gate with complemented DFF output
    assign or_out = x | (~q_or);              // OR gate with complemented DFF output

    // Instantiate the three D flip-flops
    always @(posedge clk) begin
        q_xor <= xor_out;
        q_and <= and_out;
        q_or <= or_out;
    end

    // Initial block to reset DFFs to 0 (simulation only)
    initial begin
        q_xor = 0;
        q_and = 0;
        q_or = 0;
    end

    // Output NOR gate
    assign z = ~(q_xor | q_and | q_or);

endmodule