module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// One-hot state encoding
typedef enum logic [2:0] {
    IDLE        = 3'b001,
    GOT_HIGH    = 3'b010,
    PULSE_DONE  = 3'b100
} state_t;

reg [2:0] current_state, next_state;
reg data_in_prev;

// Edge detection and state transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 1'b0;
        data_in_prev <= 1'b0;
    end
    else begin
        data_in_prev <= data_in;
        current_state <= next_state;
        
        // Registered output
        data_out <= (next_state == PULSE_DONE);
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (!data_in_prev && data_in) // rising edge
                next_state = GOT_HIGH;
            else
                next_state = IDLE;
        end
        
        GOT_HIGH: begin
            if (data_in_prev && !data_in) // falling edge
                next_state = PULSE_DONE;
            else if (!data_in) // dropped before full pulse
                next_state = IDLE;
            else
                next_state = GOT_HIGH;
        end
        
        PULSE_DONE: begin
            next_state = IDLE;
        end
        
        default: next_state = IDLE;
    endcase
end

endmodule