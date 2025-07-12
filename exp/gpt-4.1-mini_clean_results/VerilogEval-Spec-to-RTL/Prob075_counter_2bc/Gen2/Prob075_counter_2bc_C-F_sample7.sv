module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg  [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (train_valid) begin
            // Calculate next state with saturating increment/decrement
            if (train_taken) begin
                // Increment saturating at 3, only update if changed
                if (state != 2'b11)
                    state <= state + 1;
            end else begin
                // Decrement saturating at 0, only update if changed
                if (state != 2'b00)
                    state <= state - 1;
            end
            // If saturating and train_taken matches saturation, no state change -> avoid toggling
        end
        // else hold current state
    end

endmodule