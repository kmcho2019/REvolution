module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Asynchronous positive edge reset initializes to weakly not-taken state 2'b01
    // Sequential logic updates state only when train_valid is asserted

    wire [2:0] inc_val = {1'b0, state} + 3'd1;  // 3-bit to detect overflow
    wire [2:0] dec_val = {1'b0, state} - 3'd1;  // 3-bit to detect underflow

    reg [1:0] next_state;

    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Saturate increment: max 3 (2'b11)
                next_state = (inc_val[2]) ? 2'b11 : inc_val[1:0];
            end else begin
                // Saturate decrement: min 0 (2'b00)
                next_state = (dec_val[2]) ? 2'b00 : dec_val[1:0];
            end
        end else begin
            // Hold current state when not training to reduce toggling
            next_state = state;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken reset state
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold current state (no toggling)
    end

endmodule