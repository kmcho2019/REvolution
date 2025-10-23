module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Shift register implementation:
    // [0] represents current state (1 = A, 0 = B)
    // [1] represents next state
    reg [1:0] state_shift;

    // Output is current state's response to input
    assign z = state_shift[0] ? x : ~x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize shift register to represent state A
            state_shift <= 2'b11;
        end
        else begin
            // Shift operation:
            // New [1] becomes current state's next state
            // [0] shifts to [1]
            state_shift[1] <= state_shift[0] ? x : 1'b1;
            state_shift[0] <= state_shift[1];
        end
    end

endmodule