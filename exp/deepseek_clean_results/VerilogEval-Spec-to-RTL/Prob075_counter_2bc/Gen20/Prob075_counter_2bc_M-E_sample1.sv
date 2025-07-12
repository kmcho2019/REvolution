module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// One-hot encoded state definitions
localparam S0 = 2'b00;  // Strongly not-taken
localparam S1 = 2'b01;  // Weakly not-taken (reset state)
localparam S2 = 2'b10;  // Weakly taken
localparam S3 = 2'b11;  // Strongly taken

// Next state logic
reg [1:0] next_state;

always @(*) begin
    if (areset) begin
        next_state = S1;  // Reset to weakly not-taken
    end
    else if (train_valid) begin
        case (state)
            S0: next_state = train_taken ? S1 : S0;
            S1: next_state = train_taken ? S2 : S0;
            S2: next_state = train_taken ? S3 : S1;
            S3: next_state = train_taken ? S3 : S2;
            default: next_state = S1;
        endcase
    end
    else begin
        next_state = state;  // Hold current state when not training
    end
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S1;
    end
    else begin
        state <= next_state;
    end
end

endmodule