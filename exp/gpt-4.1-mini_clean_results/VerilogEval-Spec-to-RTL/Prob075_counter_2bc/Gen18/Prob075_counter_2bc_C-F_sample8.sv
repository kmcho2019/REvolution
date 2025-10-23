module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Sequential logic with async posedge reset and conditional update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                if (state != 2'b11)
                    state <= state + 1;
                else
                    state <= state; // hold at max
            end else begin
                // Decrement saturating at 0
                if (state != 2'b00)
                    state <= state - 1;
                else
                    state <= state; // hold at min
            end
        end
        // else hold current state (no toggle)
    end

endmodule