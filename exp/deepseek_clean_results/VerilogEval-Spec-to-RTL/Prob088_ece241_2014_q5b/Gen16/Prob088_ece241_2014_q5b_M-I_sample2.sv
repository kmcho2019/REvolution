module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Binary state encoding: 0 = A, 1 = B
    reg state;

    // Next state and output logic (combinational)
    wire next_state = (state | x);
    assign z = state ^ x;

    // State register updates (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset to state A (binary 0)
            state <= 1'b0;
        end else begin
            // Normal state transition
            state <= next_state;
        end
    end

endmodule