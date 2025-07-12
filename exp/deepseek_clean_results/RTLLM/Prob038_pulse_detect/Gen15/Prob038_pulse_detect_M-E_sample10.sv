module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
typedef enum logic [1:0] {
    IDLE,
    GOT_RISE,
    GOT_HIGH,
    PULSE_DETECTED
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    case (current_state)
        IDLE: begin
            data_out = 1'b0;
            if (data_in) next_state = GOT_RISE;
            else next_state = IDLE;
        end
        
        GOT_RISE: begin
            data_out = 1'b0;
            if (data_in) next_state = GOT_HIGH;
            else next_state = IDLE;  // False start
        end
        
        GOT_HIGH: begin
            data_out = 1'b0;
            if (!data_in) next_state = PULSE_DETECTED;
            else next_state = GOT_HIGH;
        end
        
        PULSE_DETECTED: begin
            data_out = 1'b1;
            next_state = IDLE;
        end
        
        default: begin
            data_out = 1'b0;
            next_state = IDLE;
        end
    endcase
end

endmodule