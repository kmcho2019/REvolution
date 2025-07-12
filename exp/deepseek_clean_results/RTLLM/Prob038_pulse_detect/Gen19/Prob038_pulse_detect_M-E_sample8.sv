module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg data_in_prev;
wire rising_edge;
wire falling_edge;

// Edge detection
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_in_prev <= 1'b0;
    end else begin
        data_in_prev <= data_in;
    end
end

assign rising_edge = ~data_in_prev & data_in;
assign falling_edge = data_in_prev & ~data_in;

// State machine
typedef enum logic [1:0] {
    IDLE,
    RISE_DETECTED,
    PULSE_DETECTED
} state_t;

state_t current_state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Output is only high for one cycle when pulse is complete
        data_out <= (next_state == PULSE_DETECTED);
    end
end

always_comb begin
    next_state = current_state;
    data_out = 1'b0;
    
    case (current_state)
        IDLE: begin
            if (rising_edge) begin
                next_state = RISE_DETECTED;
            end
        end
        
        RISE_DETECTED: begin
            if (falling_edge) begin
                next_state = PULSE_DETECTED;
            end else if (~data_in) begin
                // Pulse was too short (only 1 cycle high)
                next_state = IDLE;
            end
        end
        
        PULSE_DETECTED: begin
            next_state = IDLE;
        end
        
        default: next_state = IDLE;
    endcase
end

endmodule