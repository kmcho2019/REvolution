module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    // Combinational next state logic using saturating increment/decrement
    always @(*) begin
        if (!train_valid) begin
            next_state = state; // hold when not training
        end else if (train_taken) begin
            // Increment saturating at 3
            if (state == 2'd3)
                next_state = 2'd3;
            else
                next_state = state + 1'b1;
        end else begin
            // Decrement saturating at 0
            if (state == 2'd0)
                next_state = 2'd0;
            else
                next_state = state - 1'b1;
        end
    end

    // Sequential logic with asynchronous positive edge reset and update enable
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold current state (no toggle)
    end

endmodule