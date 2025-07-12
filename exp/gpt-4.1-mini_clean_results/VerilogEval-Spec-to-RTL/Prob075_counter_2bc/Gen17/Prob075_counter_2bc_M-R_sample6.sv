module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Reset state: weakly not-taken (2'b01)
    localparam [1:0] RESET_STATE = 2'b01;

    wire signed [2:0] delta;      // signed 3-bit to hold +1/-1/0
    wire [2:0] next_unclamped;    // 3-bit to hold intermediate next state before saturate
    reg  [1:0] next_state;

    // Compute delta: +1 if train_taken=1, -1 if train_taken=0, 0 if not valid
    assign delta = (train_valid) ? (train_taken ? 3'sd1 : -3'sd1) : 3'sd0;

    // Compute next unclamped value by sign-extending current state and adding delta
    assign next_unclamped = {1'b0, state} + delta;

    // Clamp next_unclamped to [0..3] range
    always @(*) begin
        if (!train_valid) begin
            next_state = state;
        end else if (next_unclamped[2] == 1'b1) begin
            // Negative result, clamp to 0
            next_state = 2'b00;
        end else if (next_unclamped > 3) begin
            // Overflow, clamp to 3
            next_state = 2'b11;
        end else begin
            // Within range, assign lower 2 bits
            next_state = next_unclamped[1:0];
        end
    end

    // Sequential logic: asynchronous positive edge reset, synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= RESET_STATE;
        end else begin
            state <= next_state;
        end
    end

endmodule