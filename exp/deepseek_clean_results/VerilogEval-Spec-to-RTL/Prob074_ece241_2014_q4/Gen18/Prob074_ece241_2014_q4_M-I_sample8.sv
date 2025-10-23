module TopModule (
    input clk,
    input x,
    output z
);

    // Three dedicated flip-flops for each operation
    reg xor_ff = 0;
    reg and_ff = 0;
    reg or_ff = 0;

    // Gate outputs before flip-flops
    wire xor_out = x ^ xor_ff;
    wire and_out = x & ~and_ff;
    wire or_out = x | ~or_ff;

    // Final NOR output
    assign z = ~(xor_ff | and_ff | or_ff);

    always @(posedge clk) begin
        xor_ff <= xor_out;
        and_ff <= and_out;
        or_ff <= or_out;
    end

endmodule