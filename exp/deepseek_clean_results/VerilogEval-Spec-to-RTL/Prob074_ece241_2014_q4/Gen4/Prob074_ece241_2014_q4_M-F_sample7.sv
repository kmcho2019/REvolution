module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff = 1'b0;

    // Gate outputs (combinational logic)
    wire xor_out = x ^ xor_ff;
    wire and_out = x & (~and_ff);
    wire or_out = x | (~or_ff);

    // Sequential logic (flip-flops)
    always @(posedge clk) begin
        xor_ff <= xor_out;
        and_ff <= and_out;
        or_ff <= or_out;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule