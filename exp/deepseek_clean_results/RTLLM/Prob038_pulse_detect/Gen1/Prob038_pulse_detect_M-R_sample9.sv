module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
typedef enum logic [1:0] {
    IDLE,
    GOT_0,
    GOT_1,
    PULSE_DETECTED
} state_t;

state_t current_state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Output is high only in PULSE_DETECTED state
        data_out <= (next_state == PULSE_DETECTED);
    end
end

always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = (data_in == 1'b0) ? GOT_0 : IDLE;
        end
        GOT_0: begin
            next_state = (data_in == 1'b1) ? GOT_1 : GOT_0;
        end
        GOT_1: begin
            next_state = (data_in == 1'b0) ? PULSE_DETECTED : IDLE;
        end
        PULSE_DETECTED: begin
            next_state = (data_in == 1'b0) ? GOT_0 : IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule