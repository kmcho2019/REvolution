module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Shift register implementation
    // [1] - current state (1=B, 0=A)
    // [0] - next state bit
    reg [1:0] state_shift;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_shift <= 2'b11; // Reset to state B
        end else begin
            // Shift operation embeds state transition rules:
            // For current state B (1): next state is input ? B : A
            // For current state A (0): next state is input ? A : B
            state_shift <= {state_shift[0], 
                          (state_shift[1] ? in : ~in)};
        end
    end

    // Output is the current state (MSB of shift register)
    assign out = state_shift[1];

endmodule