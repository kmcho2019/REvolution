module TopModule (
    input  clk,
    input  x,
    output z
);

    reg xor_ff, and_ff, or_ff;

    initial begin
        xor_ff = 1'b0;
        and_ff = 1'b0;
        or_ff  = 1'b0;
    end

    always @(posedge clk) begin
        xor_ff <= x ^ xor_ff;        // XOR gate: x and XOR flip-flop output
        and_ff <= x & ~and_ff;       // AND gate: x and complemented AND flip-flop output
        or_ff  <= x | ~or_ff;        // OR gate: x and complemented OR flip-flop output
    end

    assign z = ~(xor_ff | and_ff | or_ff);  // NOR of all three flip-flop outputs

endmodule