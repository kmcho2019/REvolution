module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

// Define the states explicitly for clarity
localparam S0 = 2'b00;
localparam S1 = 2'b01; // weakly not-taken initial state
localparam S2 = 2'b10;
localparam S3 = 2'b11;

reg [1:0] next_state;

always @(*) begin
    if (!train_valid) begin
        // No training, hold current state
        next_state = state;
    end else begin
        // Training valid, determine next state based on taken signal
        case (state)
            S0: next_state = (train_taken) ? S1 : S0;
            S1: next_state = (train_taken) ? S2 : S0;
            S2: next_state = (train_taken) ? S3 : S1;
            S3: next_state = (train_taken) ? S3 : S2;
            default: next_state = S1; // should never occur
        endcase
    end
end

// Sequential logic with asynchronous positive edge reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= S1; // weakly not-taken
    else
        state <= next_state;
end

endmodule