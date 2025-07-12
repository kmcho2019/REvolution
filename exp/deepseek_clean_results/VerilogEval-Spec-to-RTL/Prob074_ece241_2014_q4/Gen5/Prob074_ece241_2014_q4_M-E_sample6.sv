module TopModule (
    input clk,
    input x,
    output z
);

    // State registers
    reg xor_state = 0;
    reg and_state = 0;
    reg or_state = 0;

    // Next state logic (combinational)
    wire xor_next = x ^ xor_state;
    wire and_next = x & (~and_state);
    wire or_next = x | (~or_state);

    // Sequential update
    always @(posedge clk) begin
        xor_state <= xor_next;
        and_state <= and_next;
        or_state <= or_next;
    end

    // Output logic
    assign z = ~(xor_state | and_state | or_state);

endmodule