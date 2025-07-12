module TopModule (
    input clk,
    input x,
    output z
);

    // Feedback paths from flip-flops
    wire xor_fb = xor_ff;
    wire and_fb = ~and_ff;
    wire or_fb = ~or_ff;

    // Gate outputs (combinational logic)
    wire xor_out = x ^ xor_fb;
    wire and_out = x & and_fb;
    wire or_out = x | or_fb;

    // Sequential elements
    reg xor_ff, and_ff, or_ff;

    always @(posedge clk) begin
        xor_ff <= xor_out;
        and_ff <= and_out;
        or_ff <= or_out;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule