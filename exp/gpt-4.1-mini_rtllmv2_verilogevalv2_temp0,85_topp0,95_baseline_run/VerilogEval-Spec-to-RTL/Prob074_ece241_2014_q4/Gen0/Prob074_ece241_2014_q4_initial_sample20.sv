module TopModule (
    input clk,
    input x,
    output z
);

    reg ff_xor, ff_and, ff_or;

    wire xor_in, and_in, or_in;

    // XOR gate input: x XOR ff_xor
    assign xor_in = x ^ ff_xor;

    // AND gate input: x AND (~ff_and)
    assign and_in = x & (~ff_and);

    // OR gate input: x OR (~ff_or)
    assign or_in = x | (~ff_or);

    // On positive edge of clk, update flip-flops
    always @(posedge clk) begin
        ff_xor <= xor_in;
        ff_and <= and_in;
        ff_or  <= or_in;
    end

    // Three-input NOR gate for output z
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule