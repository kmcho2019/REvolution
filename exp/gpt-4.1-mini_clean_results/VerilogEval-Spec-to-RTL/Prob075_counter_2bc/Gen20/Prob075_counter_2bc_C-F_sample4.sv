module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    wire increment = train_valid & train_taken;
    wire decrement = train_valid & (~train_taken);

    // Combinational next state logic with saturating increment/decrement,
    // computed only when train_valid is asserted to minimize switching.
    always @(*) begin
        if (train_valid) begin
            if (increment) begin
                // saturate at max 3
                if (state == 2'd3)
                    next_state = 2'd3;
                else
                    next_state = state + 1;
            end else if (decrement) begin
                // saturate at min 0
                if (state == 2'd0)
                    next_state = 2'd0;
                else
                    next_state = state - 1;
            end else begin
                // train_valid=1 but no increment or decrement: stay
                next_state = state;
            end
        end else begin
            // no training, hold current state to reduce toggling
            next_state = state;
        end
    end

    // Sequential logic: asynchronous positive edge reset to weakly not-taken (2'b01).
    // Update state only on positive edge of clk and when train_valid=1 to reduce unnecessary toggling.
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken reset state
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold state (no toggling)
    end

endmodule