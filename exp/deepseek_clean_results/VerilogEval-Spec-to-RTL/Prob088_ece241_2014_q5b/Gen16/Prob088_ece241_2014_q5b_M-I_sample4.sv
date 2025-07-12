module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Single state bit: 0=state_A, 1=state_B
    reg state_B;
    wire z_comb;

    // Combinational output logic
    assign z_comb = state_B ? ~x : x;

    // State update and output registration with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A
            z <= 1'b0;        // Reset output
        end else begin
            state_B <= state_B | x;  // Move to B on first '1' and stay
            z <= z_comb;              // Register output
        end
    end

endmodule