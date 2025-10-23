module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state_A;  // state_B is implicit as ~state_A in one-hot encoding

    // Simplified next state logic
    wire next_state_A = state_A & ~x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            z <= 1'b0;
        end
        else begin
            state_A <= next_state_A;
            // Registered output reduces glitches
            z <= state_A ? x : ~x;
        end
    end

endmodule