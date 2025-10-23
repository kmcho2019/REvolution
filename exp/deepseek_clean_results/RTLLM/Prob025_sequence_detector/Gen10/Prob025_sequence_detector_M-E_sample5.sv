module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Pattern matching states
typedef enum logic [1:0] {
    IDLE,
    MATCHING,
    DETECTED
} top_state_t;

// Position tracking
typedef enum logic [1:0] {
    POS0,
    POS1,
    POS2,
    POS3
} pos_state_t;

top_state_t current_state, next_state;
pos_state_t current_pos, next_pos;
reg [3:0] pattern_window;
reg predicted_detection;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        current_pos <= POS0;
        pattern_window <= 4'b0;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        current_pos <= next_pos;
        
        // Update pattern window in parallel
        pattern_window <= {pattern_window[2:0], data_in};
        
        // Registered output
        sequence_detected <= (current_state == DETECTED) || 
                           (predicted_detection && (pattern_window[2:0] == 3'b100));
    end
end

// Next state logic
always @(*) begin
    next_state = current_state;
    next_pos = current_pos;
    predicted_detection = 1'b0;
    
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = MATCHING;
                next_pos = POS1;
            end
        end
        
        MATCHING: begin
            case (current_pos)
                POS1: begin
                    if (data_in == 1'b0) next_pos = POS2;
                    else next_state = IDLE;
                end
                POS2: begin
                    if (data_in == 1'b0) next_pos = POS3;
                    else next_state = IDLE;
                end
                POS3: begin
                    if (data_in == 1'b1) begin
                        next_state = DETECTED;
                        predicted_detection = 1'b1;
                    end else begin
                        next_state = IDLE;
                    end
                end
                default: next_state = IDLE;
            endcase
            
            // Early termination if pattern breaks
            if ((current_pos == POS1 && data_in != 1'b0) ||
                (current_pos == POS2 && data_in != 1'b0)) begin
                next_state = IDLE;
            end
        end
        
        DETECTED: begin
            next_state = IDLE;
        end
    endcase
end

endmodule