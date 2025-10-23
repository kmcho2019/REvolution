module TopModule (
    input        clk,
    input        areset,
    input        train_valid,
    input        train_taken,
    output reg [1:0] state
);

    wire signed [1:0] delta;
    wire [2:0] sum;
    wire [1:0] next_state;

    // Determine delta: +1 if train_valid & train_taken, -1 if train_valid & ~train_taken, else 0
    assign delta = (train_valid) ? (train_taken ? 2'sd1 : -2'sd1) : 2'sd0;

    // Compute sum with sign extension to avoid overflow on add
    assign sum = {1'b0, state} + delta; // sum is 3 bits to catch overflow/underflow

    // Saturate sum between 0 and 3
    assign next_state = (sum[2]) ? 2'b00          // Negative (underflow): clamp to 0
                      : (sum > 3) ? 2'b11        // Overflow: clamp to 3
                      : sum[1:0];

    // Sequential logic with async positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken
        else
            state <= next_state;
    end

endmodule