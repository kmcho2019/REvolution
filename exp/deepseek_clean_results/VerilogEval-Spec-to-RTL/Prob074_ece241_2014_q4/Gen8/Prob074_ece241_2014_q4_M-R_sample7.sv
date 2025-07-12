module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff = 0;
    reg and_ff = 0;
    reg or_ff = 0;

    // Next-state logic
    wire xor_next = x ^ xor_ff;
    wire and_next = x & ~and_ff;
    wire or_next = x | ~or_ff;

    // Sequential logic
    always @(posedge clk) begin
        xor_ff <= xor_next;
        and_ff <= and_next;
        or_ff <= or_next;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule