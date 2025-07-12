module TopModule (
    input  clk,
    input  x,
    output z
);

    // Individual flip-flop outputs, initialized to zero (reset)
    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff  = 1'b0;

    // Compute next state inputs for each flip-flop
    wire d_xor = x ^ xor_ff;
    wire d_and = x & (~and_ff);
    wire d_or  = x | (~or_ff);

    // Sequential update of flip-flops on positive clock edge
    always @(posedge clk) begin
        xor_ff <= d_xor;
        and_ff <= d_and;
        or_ff  <= d_or;
    end

    // Output z is the NOR of all three flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule