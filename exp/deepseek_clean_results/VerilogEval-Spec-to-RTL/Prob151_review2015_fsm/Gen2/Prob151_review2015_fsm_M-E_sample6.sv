module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // One-hot state encoding
    localparam [3:0] 
        IDLE        = 4'b0001,
        PATTERN_DET = 4'b0010,
        SHIFTING    = 4'b0100,
        COUNTING    = 4'b1000,
        COMPLETE    = 4'b0000;  // Special case for done

    reg [3:0] current_state, next_state;
    reg [1:0] shift_cnt;
    reg [3:0] data_history;

    // History tracking for parallel pattern detection
    always @(posedge clk) begin
        if (reset) begin
            data_history <= 4'b0;
        end else begin
            data_history <= {data_history[2:0], data};
        end
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_cnt <= 2'b11;  // Count down from 3 (4 cycles)
        end else begin
            current_state <= next_state;
            
            // Shift counter management
            if (current_state == SHIFTING) begin
                shift_cnt <= shift_cnt - 1;
            end else if (current_state == IDLE) begin
                shift_cnt <= 2'b11;  // Reset counter
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                // Parallel pattern detection
                if (data_history == 4'b1101) begin
                    next_state = SHIFTING;
                end else begin
                    next_state = IDLE;
                end
            end
            
            SHIFTING: begin
                if (shift_cnt == 2'b00) begin
                    next_state = COUNTING;
                end else begin
                    next_state = SHIFTING;
                end
            end
            
            COUNTING: begin
                if (done_counting) begin
                    next_state = COMPLETE;
                end else begin
                    next_state = COUNTING;
                end
            end
            
            COMPLETE: begin
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = COMPLETE;
                end
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Output logic - registered for clean timing
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            shift_ena <= (next_state == SHIFTING);
            counting <= (next_state == COUNTING);
            done <= (next_state == COMPLETE);
        end
    end

endmodule