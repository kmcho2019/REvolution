module TopModule (
    input clk,
    input x,
    output z
);

    // State registers initialized to 0
    reg xor_state = 0;
    reg and_state = 0;
    reg or_state = 0;

    // Gate inputs with proper feedback
    wire xor_in = x ^ xor_state;
    wire and_in = x & (~and_state);
    wire or_in = x | (~or_state);

    // Sequential update
    always @(posedge clk) begin
        xor_state <= xor_in;
        and_state <= and_in;
        or_state <= or_in;
    end

    // Output logic
    assign z = ~(xor_state | and_state | or_state);

endmodule