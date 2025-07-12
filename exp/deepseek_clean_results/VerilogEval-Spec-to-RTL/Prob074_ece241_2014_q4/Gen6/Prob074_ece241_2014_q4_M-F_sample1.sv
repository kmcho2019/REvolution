module TopModule (
    input clk,
    input x,
    output z
);

    // State registers
    reg xor_state;
    reg and_state;
    reg or_state;

    // Internal reset signal
    reg init_reset = 1;

    // Next state logic (combinational)
    wire xor_next = x ^ xor_state;
    wire and_next = x & (~and_state);
    wire or_next = x | (~or_state);

    // Sequential update with synchronous reset
    always @(posedge clk) begin
        if (init_reset) begin
            xor_state <= 0;
            and_state <= 0;
            or_state <= 0;
            init_reset <= 0;  // Deassert reset after first use
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