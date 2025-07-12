module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: state_A = 2'b01, state_B = 2'b10
    reg [1:0] state;

    // Next state and output logic
    wire next_state_A = (~x & state[0]) | (x & state[1]);
    wire next_state_B = (x & state[0]) | (~x & state[1]);
    assign z = (state[0] & x) | (state[1] & ~x);

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to state A (one-hot)
        end else begin
            state <= {next_state_B, next_state_A};
        end
    end

endmodule