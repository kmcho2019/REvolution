module TopModule (
    input clk,
    input x,
    output z
);

    // Individual flip-flop states
    reg xor_state;
    reg and_state;
    reg or_state;
    
    // Reset signal (active high)
    reg reset = 1'b1;
    
    // Next state logic
    wire xor_next = x ^ xor_state;
    wire and_next = x & ~and_state;
    wire or_next = x | ~or_state;
    
    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            xor_state <= 1'b0;
            and_state <= 1'b0;
            or_state <= 1'b0;
            reset <= 1'b0;  // Deassert reset after first clock
        end
        else begin
            xor_state <= xor_next;
            and_state <= and_next;
            or_state <= or_next;
        end
    end
    
    // Output logic
    assign z = ~(xor_state | and_state | or_state);

endmodule