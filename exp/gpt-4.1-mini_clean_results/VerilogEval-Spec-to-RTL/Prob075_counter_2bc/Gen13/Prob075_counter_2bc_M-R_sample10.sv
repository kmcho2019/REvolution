module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    // Combinational next_state logic with saturating increment/decrement
    always @(*) begin
        if (!train_valid) begin
            // Hold current state when not training
            next_state = state;
        end else if (train_taken) begin
            // Saturating increment
            if (state == 2'd3)
                next_state = 2'd3;
            else
                next_state = state + 2'd1;
        end else begin
            // Saturating decrement
            if (state == 2'd0)
                next_state = 2'd0;
            else
                next_state = state - 2'd1;
        end
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else begin
            // Update state only if it changes (optional power saving)
            if (next_state != state)
                state <= next_state;
            // else state holds implicitly
        end
    end

endmodule