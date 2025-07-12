module TopModule (
    input  clk,
    input  x,
    output z
);

    // Flip-flops storing the outputs of the XOR, AND, and OR gates
    reg xor_ff = 1'b0;  // initialized to zero at time zero
    reg and_ff = 1'b0;  // initialized to zero at time zero
    reg or_ff  = 1'b0;  // initialized to zero at time zero

    // Combinational logic for next state inputs
    wire xor_d = x ^ xor_ff;
    wire and_d = x & (~and_ff);
    wire or_d  = x | (~or_ff);

    // Flip-flops update on clock edge without reset
    always @(posedge clk) begin
        xor_ff <= xor_d;
        and_ff <= and_d;
        or_ff  <= or_d;
    end

    // Output z is NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule