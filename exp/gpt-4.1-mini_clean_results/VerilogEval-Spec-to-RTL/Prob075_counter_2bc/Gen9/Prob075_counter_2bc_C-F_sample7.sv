module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Explicit states for clarity
    localparam S0 = 2'b00;
    localparam S1 = 2'b01; // weakly not-taken initial state
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;

    wire enable = train_valid;
    reg  [1:0] next_state;

    // Compute next_state using saturating increment/decrement logic
    always @* begin
        if (!enable) begin
            next_state = state; // hold state
        end else if (train_taken) begin
            // saturate increment at max 3
            next_state = (state == S3) ? S3 : state + 1;
        end else begin
            // saturate decrement at min 0
            next_state = (state == S0) ? S0 : state - 1;
        end
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S1;  // reset to weakly not-taken
        else if (enable)
            state <= next_state;
        // else hold state unchanged
    end

endmodule