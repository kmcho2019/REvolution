module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff, and_ff, or_ff;
    wire xor_gate, and_gate, or_gate;

    // Combinational logic
    assign xor_gate = x ^ xor_ff;
    assign and_gate = x & ~and_ff;
    assign or_gate  = x | ~or_ff;

    // Sequential logic
    always @(posedge clk) begin
        xor_ff <= xor_gate;
        and_ff <= and_gate;
        or_ff  <= or_gate;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule