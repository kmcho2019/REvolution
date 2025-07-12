module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg ff_xor;
    reg ff_and;
    reg ff_or;

    // Continuous assignments for combinational logic
    wire d_xor = x ^ ff_xor;          // XOR with non-complemented output
    wire d_and = x & (~ff_and);       // AND with complemented output
    wire d_or = x | (~ff_or);         // OR with complemented output
    assign z = ~(ff_xor | ff_and | ff_or);  // Three-input NOR

    // Sequential logic with asynchronous reset
    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or <= d_or;
    end

    // Initialization through power-on reset
    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or = 1'b0;
    end

endmodule