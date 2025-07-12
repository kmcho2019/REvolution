module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    reg [1:0] next_state;

    // Saturating increment and decrement using arithmetic with min/max logic
    // next_state = state + 1 (max 3) if train_taken=1, train_valid=1
    // next_state = state - 1 (min 0) if train_taken=0, train_valid=1
    // else next_state = state

    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // saturating increment to max 3
                next_state = (state == 2'd3) ? 2'd3 : state + 1'b1;
            end else begin
                // saturating decrement to min 0
                next_state = (state == 2'd0) ? 2'd0 : state - 1'b1;
            end
        end else begin
            next_state = state; // hold state when not training
        end
    end

    // Sequential logic with async posedge reset and clock enable (train_valid)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken on reset
        end else if (train_valid) begin
            state <= next_state;
        end
        // else retain current state (no update)
    end

endmodule