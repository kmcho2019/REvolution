module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Explicit state encoding for clarity and verification
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;  // weakly not-taken (reset state)
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;

    reg [1:0] next_state;

    // Combinational next state logic:
    // Only compute transitions when train_valid is high to reduce switching
    always @(*) begin
        if (train_valid) begin
            case (state)
                S0: next_state = train_taken ? S1 : S0;
                S1: next_state = train_taken ? S2 : S0;
                S2: next_state = train_taken ? S3 : S1;
                S3: next_state = train_taken ? S3 : S2;
                default: next_state = S1; // safe fallback
            endcase
        end else begin
            // When not training, hold current state to minimize toggling
            next_state = state;
        end
    end

    // Sequential logic with asynchronous positive edge reset
    // Update state only when train_valid is asserted, else hold state
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S1;  // weakly not-taken initial state
        end else if (train_valid) begin
            state <= next_state;
        end
        // else retain current state, no toggling
    end

endmodule