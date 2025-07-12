module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg [1:0] state_shift;  // [1] = state_B, [0] = state_A

    // Shift register implementation
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_shift <= 2'b01;  // Reset to state A (one-hot)
        end
        else begin
            if (state_shift[0] & x) begin
                // Transition from A to B when x=1
                state_shift <= 2'b10;
            end
            // Once in state B, maintain it (no shifting needed)
        end
    end

    // Output is x when in state A, ~x when in state B
    assign z = x ^ state_shift[1];

endmodule