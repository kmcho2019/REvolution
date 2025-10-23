module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;  // state_B=0 means in A, state_B=1 means in B

    // Optimized next state logic
    wire next_state_B = state_B | (~state_B & x);

    // Efficient output logic
    assign z = state_B ? ~x : x;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A
        end else begin
            state_B <= next_state_B;
        end
    end

endmodule