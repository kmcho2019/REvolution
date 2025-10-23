module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                if (state < 2'b11)
                    next_state = state + 1'b1;
                else
                    next_state = state;
            end else begin
                // Decrement saturating at 0
                if (state > 2'b00)
                    next_state = state - 1'b1;
                else
                    next_state = state;
            end
        end else begin
            // Hold state if not training
            next_state = state;
        end
    end

    // Update state only when train_valid and next_state is different to save toggling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (train_valid && (next_state != state)) begin
            state <= next_state;
        end
        // else retain state (no toggle)
    end

endmodule