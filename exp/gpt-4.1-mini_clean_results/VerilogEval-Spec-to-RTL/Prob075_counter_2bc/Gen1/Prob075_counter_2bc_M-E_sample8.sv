module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    // Internal variable for next state calculation
    reg [2:0] next_state_wide; // 3 bits to detect overflow/underflow

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // Reset to weakly not-taken
        end else if (train_valid) begin
            // Compute tentative next state with increment or decrement
            if (train_taken) begin
                next_state_wide = state + 1'b1;
                // Clamp at max 3
                state <= (next_state_wide > 3) ? 2'b11 : next_state_wide[1:0];
            end else begin
                next_state_wide = state - 1'b1;
                // Clamp at min 0
                state <= (next_state_wide[2] == 1'b1) ? 2'b00 : next_state_wide[1:0];
                // Note: if MSB of 3-bit value is 1, it's negative (underflow)
            end
        end
        // else hold current state
    end

endmodule