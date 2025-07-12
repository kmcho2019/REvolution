module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
typedef enum logic [1:0] {
    IDLE,       // Waiting for first 0
    FIRST_1,    // Saw 0->1 transition
    SECOND_0,   // Saw 1->0 transition
    DETECT      // Pulse detected
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

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b0)
                next_state = FIRST_1;
            else
                next_state = IDLE;
        end
        
        FIRST_1: begin
            if (data_in == 1'b1)
                next_state = SECOND_0;
            else
                next_state = FIRST_1;
        end
        
        SECOND_0: begin
            if (data_in == 1'b0)
                next_state = DETECT;
            else
                next_state = IDLE;
        end
        
        DETECT: begin
            next_state = IDLE;
        end
        
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 1'b0;
    end
    else begin
        data_out <= (current_state == DETECT) ? 1'b1 : 1'b0;
    end
end

endmodule