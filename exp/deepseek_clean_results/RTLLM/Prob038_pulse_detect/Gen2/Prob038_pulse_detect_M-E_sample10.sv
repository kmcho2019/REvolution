module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
typedef enum logic [1:0] {
    IDLE,    // Waiting for initial 0
    SAW_0,   // Saw first 0, waiting for 1
    SAW_1,   // Saw 1, waiting for 0
    PULSE    // Complete pulse detected
} state_t;

state_t current_state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 0;
    end else begin
        current_state <= next_state;
        
        // Output is high only in PULSE state
        data_out <= (next_state == PULSE);
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? IDLE : SAW_0;
        SAW_0: next_state = data_in ? SAW_1 : SAW_0;
        SAW_1: next_state = data_in ? IDLE : PULSE;
        PULSE: next_state = data_in ? IDLE : SAW_0;
        default: next_state = IDLE;
    endcase
end

endmodule