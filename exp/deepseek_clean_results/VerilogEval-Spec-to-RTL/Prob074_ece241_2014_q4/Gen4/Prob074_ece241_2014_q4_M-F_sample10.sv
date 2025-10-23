module TopModule (
    input clk,
    input x,
    output z
);

    // Three separate flip-flops for each path
    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff = 1'b0;

    // XOR path: x XOR flip-flop's output
    wire xor_out = x ^ xor_ff;
    
    // AND path: x AND flip-flop's complemented output
    wire and_out = x & ~and_ff;
    
    // OR path: x OR flip-flop's complemented output
    wire or_out = x | ~or_ff;

    // Update flip-flops on clock edge
    always @(posedge clk) begin
        xor_ff <= xor_out;
        and_ff <= and_out;
        or_ff <= or_out;
    end

    // Output is NOR of all three flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule