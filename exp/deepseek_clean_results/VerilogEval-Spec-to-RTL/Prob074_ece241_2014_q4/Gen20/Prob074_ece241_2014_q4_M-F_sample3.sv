module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs (Q outputs)
    reg xor_q, and_q, or_q;
    
    // Next state values (D inputs)
    wire xor_d, and_d, or_d;

    // Reset signal (active high)
    wire reset = 1'b0;  // No external reset, but structured for expansion

    // Gate implementations with proper feedback
    assign xor_d = x ^ xor_q;          // XOR with previous output
    assign and_d = x & (~and_q);       // AND with complemented previous output
    assign or_d  = x | (~or_q);        // OR with complemented previous output

    // Three-input NOR of flip-flop outputs
    assign z = ~(xor_q | and_q | or_q);

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            xor_q <= 1'b0;
            and_q <= 1'b0;
            or_q  <= 1'b0;
        end else begin
            xor_q <= xor_d;
            and_q <= and_d;
            or_q  <= or_d;
        end
    end

endmodule