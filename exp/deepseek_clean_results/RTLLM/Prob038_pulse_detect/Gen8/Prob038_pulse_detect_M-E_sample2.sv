module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
typedef enum logic [1:0] {
    IDLE,
    GOT_0,
    GOT_1,
    PULSE_DETECTED
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Output is only high in PULSE_DETECTED state
        data_out <= (next_state == PULSE_DETECTED);
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = data_in ? IDLE : GOT_0;
        end
        GOT_0: begin
            next_state = data_in ? GOT_1 : GOT_0;
        end
        GOT_1: begin
            next_state = data_in ? IDLE : PULSE_DETECTED;
        end
        PULSE_DETECTED: begin
            next_state = data_in ? IDLE : GOT_0;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule