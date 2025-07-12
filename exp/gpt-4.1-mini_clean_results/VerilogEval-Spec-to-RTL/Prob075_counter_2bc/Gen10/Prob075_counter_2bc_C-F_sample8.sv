module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

// Explicit state encoding for clarity and verification
localparam S0 = 2'b00;
localparam S1 = 2'b01; // weakly not-taken initial state
localparam S2 = 2'b10;
localparam S3 = 2'b11;

reg [1:0] next_state;

// Combinational next state logic with saturating increment/decrement
always @(*) begin
    if (!train_valid) begin
        next_state = state; // hold current state if no training
    end else begin
        // Saturating transitions modeled explicitly as FSM
        case (state)
            S0: next_state = train_taken ? S1 : S0;
            S1: next_state = train_taken ? S2 : S0;
            S2: next_state = train_taken ? S3 : S1;
            S3: next_state = train_taken ? S3 : S2;
            default: next_state = S1; // safe fallback
        endcase
    end
end

// Update enable to avoid unnecessary toggling and reduce power
wire update_enable = (next_state != state) && train_valid;

// Sequential logic with asynchronous positive edge reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= S1; // reset to weakly not-taken
    else if (update_enable)
        state <= next_state;
    // else hold current state implicitly
end

endmodule