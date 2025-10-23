module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // 2-bit shift register for state representation
    reg [1:0] state_reg;

    // Next state is current input shifted into the register
    wire [1:0] next_state = {state_reg[0], x};

    // Output is XOR of current input and whether we've seen a 1 before
    assign z = x ^ state_reg[1];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= 2'b00;  // Reset to initial state (A)
        end else begin
            state_reg <= next_state;
        end
    end

endmodule