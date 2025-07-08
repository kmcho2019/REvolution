module TopModule (
    input clk,
    input x,
    output z
);

    reg ff_xor;
    reg ff_and;
    reg ff_or;

    wire d_xor;
    wire d_and;
    wire d_or;

    // XOR gate: x and ff_xor output
    assign d_xor = x ^ ff_xor;
    // AND gate: x and complement of ff_and output
    assign d_and = x & (~ff_and);
    // OR gate: x and complement of ff_or output
    assign d_or = x | (~ff_or);

    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or  <= d_or;
    end

    // NOR gate of the three flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or  = 1'b0;
    end

endmodule