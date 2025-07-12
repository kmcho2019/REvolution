module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // 2-bit shift register for state representation
    reg [1:0] state_shift;

    // Shift register update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_shift <= 2'b11;  // Async reset to state B (encoded as MSB=1, LSB=1)
        end else begin
            // Shift in next state bit based on current state (LSB) and input
            state_shift <= {state_shift[0], (state_shift[0] ? in : ~in)};
        end
    end

    // Output is the LSB of the shift register (Moore machine)
    assign out = state_shift[0];

endmodule