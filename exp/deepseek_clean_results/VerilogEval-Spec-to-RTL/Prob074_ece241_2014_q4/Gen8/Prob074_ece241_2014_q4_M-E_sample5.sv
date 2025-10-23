module TopModule (
    input clk,
    input x,
    output z
);

    // Feedback registers with integrated input logic
    reg xor_reg = 0;
    reg and_reg = 0;
    reg or_reg = 0;

    // XOR path: x XOR previous xor_reg value
    wire xor_input = x ^ xor_reg;

    // AND path: x AND (NOT previous and_reg value)
    wire and_input = x & ~and_reg;

    // OR path: x OR (NOT previous or_reg value)
    wire or_input = x | ~or_reg;

    // Register updates
    always @(posedge clk) begin
        xor_reg <= xor_input;
        and_reg <= and_input;
        or_reg <= or_input;
    end

    // Output NOR gate
    assign z = ~(xor_reg | and_reg | or_reg);

endmodule