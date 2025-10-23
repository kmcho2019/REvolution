module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define states
typedef enum logic [2:0] {
    IDLE,
    PATTERN_DETECTED,
    SHIFTING,
    COUNTING,
    DONE
} state_type;

state_type current_state, next_state;

reg [3:0] pattern;
reg [3:0] shift_counter;

// Shift register to store the input pattern
always @(posedge clk) begin
    if(reset) begin
        pattern <= 4'b0;
    end else if(current_state == IDLE) begin
        pattern <= {pattern[2:0], data};
    end
end

// State register
always @(posedge clk) begin
    if(reset) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// FSM logic
always @(*) begin
    next_state = current_state;
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    
    case(current_state)
        IDLE: begin
            if(pattern == 4'b1101) begin
                next_state = PATTERN_DETECTED;
            end
        end
        PATTERN_DETECTED: begin
            next_state = SHIFTING;
            shift_ena = 1'b1;
            shift_counter = 4'b0001;
        end
        SHIFTING: begin
            shift_ena = 1'b1;
            if(shift_counter == 4'b1000) begin
                next_state = COUNTING;
            end else begin
                shift_counter = shift_counter + 1'b1;
            end
        end
        COUNTING: begin
            counting = 1'b1;
            if(done_counting) begin
                next_state = DONE;
            end
        end
        DONE: begin
            done = 1'b1;
            if(ack) begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule