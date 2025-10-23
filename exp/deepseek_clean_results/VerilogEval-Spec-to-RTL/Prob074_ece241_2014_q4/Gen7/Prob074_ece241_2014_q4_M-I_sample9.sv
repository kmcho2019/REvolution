module TopModule (
    input clk,
    input x,
    output z
);

    // State registers with synchronous reset
    reg xor_state = 1'b0;
    reg and_state = 1'b0;
    reg or_state = 1'b0;

    always @(posedge clk) begin
        xor_state <= x ^ xor_state;
        and_state <= x & ~and_state;
        or_state <= x | ~or_state;
    end

    // Output logic using reduction NOR
    assign z = ~|{xor_state, and_state, or_state};

endmodule