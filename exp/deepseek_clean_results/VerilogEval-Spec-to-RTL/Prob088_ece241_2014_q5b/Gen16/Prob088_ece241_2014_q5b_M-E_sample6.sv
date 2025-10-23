module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Gray code state encoding:
    // state 0 = A (00)
    // state 1 = B (01)
    reg state;  // Only need 1 bit for 2 states

    // Next state logic
    wire next_state = (state == 0) ? x : 1'b1;

    // Output pipeline register
    reg next_z;
    always @(*) begin
        if (state == 0)
            next_z = x;    // State A
        else
            next_z = ~x;   // State B
    end

    // State and output registers with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to state A
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule