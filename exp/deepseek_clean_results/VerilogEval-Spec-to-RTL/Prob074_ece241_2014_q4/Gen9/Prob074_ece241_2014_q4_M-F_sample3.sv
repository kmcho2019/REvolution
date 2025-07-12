module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;

    // Combinational logic for each path
    wire xor_input = x ^ xor_ff;
    wire and_input = x & ~and_ff;
    wire or_input = x | ~or_ff;

    // Synchronous flip-flop updates with implicit reset to 0
    always @(posedge clk) begin
        xor_ff <= xor_input;
        and_ff <= and_input;
        or_ff <= or_input;
    end

    // Output NOR gate
    assign z = ~(xor_ff | and_ff | or_ff);

    // Initial block for simulation only (not for synthesis)
    initial begin
        xor_ff = 0;
        and_ff = 0;
        or_ff = 0;
    end

endmodule