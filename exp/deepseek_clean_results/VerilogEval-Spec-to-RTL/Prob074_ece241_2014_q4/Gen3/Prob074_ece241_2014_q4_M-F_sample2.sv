module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff = 0;
    reg and_ff = 0;
    reg or_ff = 0;

    // Feedback signals
    wire xor_fb = xor_ff;
    wire and_fb = ~and_ff;
    wire or_fb = ~or_ff;

    // Gate inputs
    wire xor_in = x ^ xor_fb;
    wire and_in = x & and_fb;
    wire or_in = x | or_fb;

    // Sequential logic (flip-flops)
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff <= or_in;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule