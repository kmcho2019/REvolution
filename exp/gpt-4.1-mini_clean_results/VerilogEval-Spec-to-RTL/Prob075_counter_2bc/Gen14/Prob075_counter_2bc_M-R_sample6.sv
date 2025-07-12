module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire [1:0] next_state;

    // Compute next state with saturating increment/decrement
    // Increment if train_taken=1, decrement if 0, only if train_valid=1; else hold current state.
    // Saturate between 2'b00 and 2'b11.
    wire increment = train_valid & train_taken;
    wire decrement = train_valid & ~train_taken;

    wire [2:0] inc_state = {1'b0, state} + 3'd1; // 3-bit to detect overflow
    wire [2:0] dec_state = {1'b0, state} - 3'd1; // 3-bit to detect underflow

    assign next_state = (train_valid) ? 
                        (increment ? (inc_state[2] ? 2'b11 : inc_state[1:0]) : 
                         (decrement ? (state == 2'b00 ? 2'b00 : dec_state[1:0]) : state))
                        : state;

    // State register with asynchronous positive-edge reset and update enable on train_valid
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold current state
    end

endmodule