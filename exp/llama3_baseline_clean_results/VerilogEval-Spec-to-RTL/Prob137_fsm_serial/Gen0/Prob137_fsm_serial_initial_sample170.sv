module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Enum for states
typedef enum logic [1:0] {
    IDLE,
    START,
    DATA,
    STOP
} state_t;

// Current state and next state
state_t current_state, next_state;

// Counter for data bits
reg [2:0] data_counter;

always @(*) begin
    // Default next state is current state
    next_state = current_state;
    
    // Default done is 0
    done = 0;
    
    case (current_state)
        IDLE: begin
            // If input is 0, transition to START state
            if (!in) next_state = START;
        end
        START: begin
            // Always transition to DATA state
            next_state = DATA;
        end
        DATA: begin
            // If data_counter is 7, transition to STOP state
            if (data_counter == 7) next_state = STOP;
            else next_state = DATA;
        end
        STOP: begin
            // If input is 1, transition to IDLE state and assert done
            if (in) begin
                next_state = IDLE;
                done = 1;
            end
            // If input is 0, stay in STOP state and wait for stop bit
            else next_state = STOP;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        // Reset state and counter
        current_state <= IDLE;
        data_counter <= 0;
    end else begin
        // Update state
        current_state <= next_state;
        
        // Update data counter
        case (current_state)
            START: data_counter <= 0;
            DATA: data_counter <= data_counter + 1;
            STOP: data_counter <= 0;
            default: data_counter <= data_counter;
        endcase
    end
end

endmodule