module TopModule (
    input clk,
    input x,
    output z
);

    // Three D flip-flops with their respective input logic
    reg xor_ff = 0;
    reg and_ff = 0;
    reg or_ff = 0;

    // XOR path
    wire xor_in = x ^ xor_ff;

    // AND path
    wire and_in = x & ~and_ff;

    // OR path
    wire or_in = x | ~or_ff;

    // Update flip-flops on clock edge
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff <= or_in;
    end

    // Output is NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule