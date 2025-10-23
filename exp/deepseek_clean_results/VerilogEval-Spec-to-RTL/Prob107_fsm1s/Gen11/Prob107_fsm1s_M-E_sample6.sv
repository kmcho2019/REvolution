module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // 2-bit shift register [next_state, current_state]
    reg [1:0] state_reg;

    always @(posedge clk) begin
        if (reset) begin
            state_reg <= 2'b10;  // Reset to state B (MSB=1)
        end else begin
            // Shift operation with input-controlled next state
            state_reg <= {state_reg[0] ^ in, state_reg[1]};
        end
    end

    // Output is complement of current state (MSB of shift register)
    assign out = ~state_reg[1];

endmodule