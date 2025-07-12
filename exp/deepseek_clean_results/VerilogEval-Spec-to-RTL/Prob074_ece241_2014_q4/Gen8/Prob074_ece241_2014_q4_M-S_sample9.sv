module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_state, and_state, or_state;

    always @(posedge clk) begin
        xor_state <= x ^ xor_state;
        and_state <= x & ~and_state;
        or_state  <= x | ~or_state;
    end

    assign z = ~(xor_state | and_state | or_state);

endmodule