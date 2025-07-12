module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    always @(*) begin
        if (!train_valid) begin
            // Hold current state if not training
            next_state = state;
        end else begin
            // Update saturating counter based on train_taken
            if (train_taken) begin
                // Increment saturating at 3
                if (state == 2'd3)
                    next_state = 2'd3;
                else
                    next_state = state + 2'd1;
            end else begin
                // Decrement saturating at 0
                if (state == 2'd0)
                    next_state = 2'd0;
                else
                    next_state = state - 2'd1;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule