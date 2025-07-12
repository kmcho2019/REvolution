module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Single state register (state_A)
    reg state_A;
    wire state_B = ~state_A;

    // Next state logic simplified
    wire next_state_A = state_A & ~x;

    // Output logic (registered)
    wire next_z = state_A ? x : ~x;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            z <= 1'b0;
        end
        else begin
            state_A <= next_state_A;
            z <= next_z;
        end
    end

endmodule