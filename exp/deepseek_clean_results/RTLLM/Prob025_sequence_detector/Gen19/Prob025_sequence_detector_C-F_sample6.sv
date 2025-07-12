module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding tracks progress toward 1001
typedef enum logic [1:0] {
    IDLE,       // No relevant bits matched
    GOT1,       // First '1' matched
    GOT10,      // '10' matched
    GOT100      // '100' matched
} state_t;

state_t current_state, next_state;

// State transition logic
always_comb begin
    case (current_state)
        IDLE:   next_state = data_in ? GOT1 : IDLE;
        GOT1:   next_state = data_in ? GOT1 : GOT10;
        GOT10:  next_state = data_in ? GOT1 : GOT100;
        GOT100: next_state = data_in ? GOT1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// State update and output generation
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        // Detect when we're in GOT100 and get a '1'
        sequence_detected <= (current_state == GOT100) && data_in;
    end
end

endmodule