module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff, and_ff, or_ff;

    // Sequential logic with implicit initialization to 0
    always @(posedge clk) begin
        xor_ff <= x ^ xor_ff;        // XOR with its own output
        and_ff <= x & ~and_ff;       // AND with complemented output
        or_ff  <= x | ~or_ff;        // OR with complemented output
    end

    // Combinational output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule