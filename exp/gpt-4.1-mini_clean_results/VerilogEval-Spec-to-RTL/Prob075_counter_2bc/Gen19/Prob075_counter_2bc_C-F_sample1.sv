module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    wire [2:0] incr_state = state + 1;  // 3-bit to detect overflow
    wire [2:0] decr_state = state - 1;  // 3-bit to detect underflow

    reg [1:0] next_state;

    always @(*) begin
        if (!train_valid) begin
            // Hold state when not training
            next_state = state;
        end else if (train_taken) begin
            // Increment saturating at max 3
            next_state = (incr_state[2]) ? 2'b11 : incr_state[1:0];
        end else begin
            // Decrement saturating at min 0
            next_state = (state == 2'b00) ? 2'b00 : decr_state[1:0];
        end
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule