module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Constants for saturation bounds
    localparam [1:0] MIN_STATE = 2'b00;
    localparam [1:0] MAX_STATE = 2'b11;
    localparam [1:0] RESET_STATE = 2'b01; // weakly not-taken

    reg [2:0] sum;  // 3-bit to detect overflow/underflow safely
    reg [1:0] next_state;

    always @(*) begin
        if (!train_valid) begin
            next_state = state; // hold when not training
        end else begin
            if (train_taken) begin
                sum = state + 1'b1;
                // saturate at MAX_STATE
                next_state = (sum > MAX_STATE) ? MAX_STATE : sum[1:0];
            end else begin
                sum = state - 1'b1;
                // saturate at MIN_STATE
                next_state = (sum[2] == 1'b1) ? MIN_STATE : sum[1:0]; // sum[2] is sign bit
            end
        end
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= RESET_STATE;
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold current state
    end

endmodule