module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff = 0, and_ff = 0, or_ff = 0;
    wire xor_next, and_next, or_next;

    // Combinational logic for gate outputs
    assign xor_next = x ^ xor_ff;
    assign and_next = x & ~and_ff;
    assign or_next  = x | ~or_ff;

    // Sequential logic (flip-flops)
    always @(posedge clk) begin
        xor_ff <= xor_next;
        and_ff <= and_next;
        or_ff  <= or_next;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule