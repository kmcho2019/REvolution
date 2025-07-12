module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire [1:0] next_state_inc;
    wire [1:0] next_state_dec;
    wire [1:0] next_state;

    // Saturating increment: max 3
    assign next_state_inc = (state == 2'd3) ? 2'd3 : state + 1;
    // Saturating decrement: min 0
    assign next_state_dec = (state == 2'd0) ? 2'd0 : state - 1;

    // Select next state based on train_taken when train_valid asserted
    assign next_state = train_taken ? next_state_inc : next_state_dec;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken reset state
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold state unchanged
    end

endmodule