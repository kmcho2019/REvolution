module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

// State encoding for clarity (optional)
localparam S0 = 2'b00;
localparam S1 = 2'b01; // weakly not-taken initial state
localparam S2 = 2'b10;
localparam S3 = 2'b11;

reg [1:0] next_state;

always @(*) begin
    if (!train_valid) begin
        // Hold current state when not training
        next_state = state;
    end else if (train_taken) begin
        // Increment saturating at 3
        next_state = (state == S3) ? S3 : state + 1'b1;
    end else begin
        // Decrement saturating at 0
        next_state = (state == S0) ? S0 : state - 1'b1;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= S1; // weakly not-taken
    else
        state <= next_state;
end

endmodule