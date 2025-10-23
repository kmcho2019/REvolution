module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Define states as parameters for better readability
localparam STRONG_NOT_TAKEN = 2'b00;
localparam WEAK_NOT_TAKEN   = 2'b01;
localparam WEAK_TAKEN       = 2'b10;
localparam STRONG_TAKEN     = 2'b11;

// Reset value (weakly not-taken)
localparam RESET_VALUE = WEAK_NOT_TAKEN;

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= RESET_VALUE;
    end
    else if (train_valid) begin
        case (state)
            STRONG_NOT_TAKEN: state <= train_taken ? WEAK_NOT_TAKEN : STRONG_NOT_TAKEN;
            WEAK_NOT_TAKEN:   state <= train_taken ? WEAK_TAKEN : STRONG_NOT_TAKEN;
            WEAK_TAKEN:      state <= train_taken ? STRONG_TAKEN : WEAK_NOT_TAKEN;
            STRONG_TAKEN:     state <= train_taken ? STRONG_TAKEN : WEAK_TAKEN;
            default:         state <= RESET_VALUE;
        endcase
    end
    // else keep current state
end

endmodule