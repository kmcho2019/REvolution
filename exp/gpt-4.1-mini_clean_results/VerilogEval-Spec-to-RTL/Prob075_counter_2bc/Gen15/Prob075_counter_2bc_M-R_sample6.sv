module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

// Calculate next state using arithmetic saturation
wire [2:0] incremented = state + 1; // 3 bits to detect overflow
wire [2:0] decremented = state - 1; // 3 bits to detect underflow

wire [1:0] next_state =
    (!train_valid) ? state :
    (train_taken)  ? ((incremented[2] || incremented > 3) ? 2'b11 : incremented[1:0]) : 
                     ((state == 2'b00) ? 2'b00 : decremented[1:0]);

// Sequential logic with asynchronous positive edge reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // weakly not-taken
    else
        state <= next_state;
end

endmodule