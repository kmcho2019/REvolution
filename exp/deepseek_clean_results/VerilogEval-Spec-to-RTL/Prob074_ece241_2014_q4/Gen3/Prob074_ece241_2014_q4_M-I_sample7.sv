module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff = 1'b0;

    // Feedback signals
    wire xor_feedback = xor_ff;
    wire and_feedback = ~and_ff;
    wire or_feedback = ~or_ff;

    // Gate inputs
    wire xor_in = x ^ xor_feedback;
    wire and_in = x & and_feedback;
    wire or_in = x | or_feedback;

    // Sequential logic
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff <= or_in;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule