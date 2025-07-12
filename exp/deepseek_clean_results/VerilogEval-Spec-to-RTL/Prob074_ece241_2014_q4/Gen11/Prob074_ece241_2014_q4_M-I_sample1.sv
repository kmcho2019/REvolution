module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff, and_ff, or_ff;

    // Combinational logic for each gate with proper feedback
    wire xor_next = x ^ xor_ff;
    wire and_next = x & ~and_ff;
    wire or_next  = x | ~or_ff;

    // Sequential update of all flip-flops
    always @(posedge clk) begin
        xor_ff <= xor_next;
        and_ff <= and_next;
        or_ff  <= or_next;
    end

    // Output logic - NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

    // Initialization (synthesis will handle this properly)
    initial begin
        xor_ff = 1'b0;
        and_ff = 1'b0;
        or_ff  = 1'b0;
    end

endmodule