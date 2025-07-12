module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Saturating counter bounds
    localparam [1:0] MIN_STATE = 2'd0;
    localparam [1:0] MAX_STATE = 2'd3;
    localparam [1:0] RESET_STATE = 2'd1; // weakly not-taken

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= RESET_STATE;
        end else if (train_valid) begin
            if (train_taken) begin
                // Increment if not saturated
                if (state != MAX_STATE) 
                    state <= state + 1'b1;
                // else no change (reduce toggling)
            end else begin
                // Decrement if not saturated
                if (state != MIN_STATE) 
                    state <= state - 1'b1;
                // else no change
            end
        end
        // else keep state unchanged (do nothing)
    end

endmodule