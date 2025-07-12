module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    wire [1:0] incremented;
    wire [1:0] decremented;
    reg  [1:0] next_state;
    wire        enable;

    // Compute increment and decrement with saturation
    assign incremented = (state == 2'b11) ? 2'b11 : state + 1'b1;
    assign decremented = (state == 2'b00) ? 2'b00 : state - 1'b1;

    // Enable updating state only when train_valid is high
    assign enable = train_valid;

    always @(*) begin
        if (!train_valid) begin
            next_state = state; // hold
        end else begin
            next_state = train_taken ? incremented : decremented;
        end
    end

    // Sequential logic with asynchronous positive edge reset
    // State updates only when enable (train_valid) is high
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken on reset
        end else if (enable) begin
            state <= next_state;
        end
    end

endmodule