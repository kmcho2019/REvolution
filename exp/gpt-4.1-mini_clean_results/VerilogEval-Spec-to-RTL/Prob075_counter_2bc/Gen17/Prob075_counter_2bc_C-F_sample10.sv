module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    // Combinational logic for saturating counter with arithmetic and min/max saturation
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Saturating increment: max 3
                if (state == 2'd3)
                    next_state = 2'd3;
                else
                    next_state = state + 1'b1;
            end else begin
                // Saturating decrement: min 0
                if (state == 2'd0)
                    next_state = 2'd0;
                else
                    next_state = state - 1'b1;
            end
        end else begin
            // Hold current state when not training to reduce toggling
            next_state = state;
        end
    end

    // Sequential logic with asynchronous positive edge reset
    // Update state only on train_valid to reduce unnecessary toggling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken reset state
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold state (no toggling)
    end

endmodule