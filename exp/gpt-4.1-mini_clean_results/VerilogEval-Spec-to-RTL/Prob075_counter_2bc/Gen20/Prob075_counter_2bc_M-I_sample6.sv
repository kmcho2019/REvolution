module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Direction encoding: +1 for increment, -1 for decrement, 0 for hold
    wire signed [1:0] dir = train_valid ? (train_taken ? 2'sd1 : -2'sd1) : 2'sd0;

    wire signed [2:0] sum = $signed({1'b0,state}) + dir; // extend to 3 bits to prevent overflow

    // Saturate sum to 2'b00..2'b11
    wire [1:0] next_state = (sum < 0)   ? 2'b00 :
                            (sum > 3)   ? 2'b11 :
                                          sum[1:0];

    // Enable updating state only when train_valid is asserted to reduce toggling
    wire enable = train_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken reset state
        end else if (enable) begin
            state <= next_state;
        end
    end

endmodule