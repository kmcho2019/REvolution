module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// One-hot encoded state definitions
localparam STATE_00 = 2'b00;
localparam STATE_01 = 2'b01;
localparam STATE_10 = 2'b10;
localparam STATE_11 = 2'b11;

// Next state logic
reg [1:0] next_state;

always @(*) begin
    if (areset) begin
        next_state = STATE_01;  // Weakly not-taken on reset
    end
    else if (train_valid) begin
        case (state)
            STATE_00: next_state = train_taken ? STATE_01 : STATE_00;
            STATE_01: next_state = train_taken ? STATE_10 : STATE_00;
            STATE_10: next_state = train_taken ? STATE_11 : STATE_01;
            STATE_11: next_state = train_taken ? STATE_11 : STATE_10;
            default:  next_state = STATE_01;  // Should never happen
        endcase
    end
    else begin
        next_state = state;  // Hold current state when not training
    end
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= STATE_01;
    else
        state <= next_state;
end

endmodule