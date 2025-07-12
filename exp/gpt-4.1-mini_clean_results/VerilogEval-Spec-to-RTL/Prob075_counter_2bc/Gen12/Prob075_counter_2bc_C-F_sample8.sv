module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    // State encoding for clarity (optional but improves readability)
    localparam S0 = 2'd0;
    localparam S1 = 2'd1;  // weakly not-taken (reset state)
    localparam S2 = 2'd2;
    localparam S3 = 2'd3;

    wire [2:0] next_state_arith; // 3 bits to avoid overflow on +1/-1

    // Arithmetic saturating next state calculation:
    // If train_valid=1, increment if train_taken=1 (max 3), else decrement (min 0)
    // Else hold current state.
    assign next_state_arith = train_valid ? 
                                (train_taken ? 
                                    ((state == S3) ? 3'd3 : state + 3'd1) :
                                    ((state == S0) ? 3'd0 : state - 3'd1)
                                ) 
                              : state;

    // Register update only if train_valid=1 and state changes to reduce toggling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S1; // weakly not-taken reset state
        end else if (train_valid && (state != next_state_arith[1:0])) begin
            state <= next_state_arith[1:0];
        end
        // else retain current state (no update)
    end

endmodule