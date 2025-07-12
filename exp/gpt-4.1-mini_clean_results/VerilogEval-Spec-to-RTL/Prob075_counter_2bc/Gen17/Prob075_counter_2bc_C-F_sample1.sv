module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Explicit states for clarity and verification
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;  // weakly not-taken (reset state)
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;

    reg [1:0] next_state;

    // Saturating increment/decrement combinational logic
    always @(*) begin
        if (!train_valid) begin
            next_state = state; // hold state if not training
        end else begin
            if (train_taken) begin
                // Saturating increment
                if (state == S3)
                    next_state = S3;
                else
                    next_state = state + 1;
            end else begin
                // Saturating decrement
                if (state == S0)
                    next_state = S0;
                else
                    next_state = state - 1;
            end
        end
    end

    // Asynchronous positive edge reset, update state only when train_valid
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S1;  // weakly not-taken reset state
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold state, minimizing toggling and power
    end

endmodule