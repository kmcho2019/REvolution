module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    wire signed [2:0] delta;
    wire signed [3:0] next_state_signed;

    // Compute increment/decrement: +1 if train_valid & train_taken, -1 if train_valid & ~train_taken, else 0
    assign delta = (train_valid) ? (train_taken ? 3'sd1 : -3'sd1) : 3'sd0;

    // Add delta to current state (extended to signed 3-bit for safe addition)
    assign next_state_signed = $signed({1'b0, state}) + delta;

    // Saturate next_state between 0 and 3
    wire [1:0] next_state = (next_state_signed < 0) ? 2'd0 :
                            (next_state_signed > 3) ? 2'd3 :
                            next_state_signed[1:0];

    // Sequential logic with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // weakly not-taken
        else
            state <= next_state;
    end

endmodule