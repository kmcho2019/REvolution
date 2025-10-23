module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff, and_ff, or_ff;
    wire xor_out, and_out, or_out;

    // Combinational logic for gate outputs
    assign xor_out = x ^ xor_ff;
    assign and_out = x & ~and_ff;
    assign or_out = x | ~or_ff;

    // Sequential logic (flip-flops)
    always @(posedge clk) begin
        xor_ff <= xor_out;
        and_ff <= and_out;
        or_ff <= or_out;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule