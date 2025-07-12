module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff = 1'b0;
    wire xor_gate, and_gate, or_gate;

    // Combinational logic for the gates
    assign xor_gate = x ^ xor_ff;      // XOR with its own output
    assign and_gate = x & ~and_ff;     // AND with complemented output
    assign or_gate  = x | ~or_ff;      // OR with complemented output

    // Sequential logic (flip-flops) with explicit initialization
    always @(posedge clk) begin
        xor_ff <= xor_gate;
        and_ff <= and_gate;
        or_ff  <= or_gate;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);  // 3-input NOR

endmodule