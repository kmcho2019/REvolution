module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff, and_ff, or_ff;

    always @(posedge clk) begin
        xor_ff <= x ^ xor_ff;       // XOR with own output
        and_ff <= x & ~and_ff;      // AND with complemented output
        or_ff  <= x | ~or_ff;       // OR with complemented output
    end

    assign z = ~(xor_ff | and_ff | or_ff);  // Three-input NOR

endmodule