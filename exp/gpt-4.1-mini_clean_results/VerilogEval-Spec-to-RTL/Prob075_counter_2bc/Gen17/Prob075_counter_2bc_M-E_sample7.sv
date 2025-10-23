module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire [2:0] incremented;
    wire [2:0] decremented;

    // Arithmetic saturation logic for increment and decrement
    assign incremented = (state == 2'd3) ? 3'd3 : state + 1;
    assign decremented = (state == 2'd0) ? 3'd0 : state - 1;

    // Next state computation using arithmetic and saturate
    wire [1:0] next_state = train_taken ? incremented[1:0] : decremented[1:0];

    // Enable signal for updating state only when train_valid is asserted
    wire enable = train_valid;

    // Sequential logic with synchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken on reset
        end else if (enable) begin
            state <= next_state;
        end
        // else hold current state
    end

endmodule