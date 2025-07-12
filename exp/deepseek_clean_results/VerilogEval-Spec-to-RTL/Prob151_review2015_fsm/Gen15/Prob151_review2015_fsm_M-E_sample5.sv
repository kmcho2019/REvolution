module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        CAPTURE,
        COUNT,
        NOTIFY
    } state_t;
    
    state_t current_state, next_state;
    
    // Pattern and shift control
    reg [3:0] shift_reg;
    reg [1:0] cycle_count;
    
    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_reg <= 4'b0;
            cycle_count <= 2'b0;
        end else begin
            current_state <= next_state;
            
            // Shift register operates in all states except NOTIFY
            if (current_state != NOTIFY) begin
                shift_reg <= {shift_reg[2:0], data};
            end
            
            // Cycle counter for CAPTURE state
            if (current_state == CAPTURE) begin
                cycle_count <= cycle_count + 1'b1;
            end else begin
                cycle_count <= 2'b0;
            end
        end
    end
    
    // Next state logic
    always @(*) begin
        next_state = current_state;
        
        case (current_state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    next_state = CAPTURE;
                end
            end
            
            CAPTURE: begin
                if (cycle_count == 2'b11) begin  // After 4 cycles
                    next_state = COUNT;
                end
            end
            
            COUNT: begin
                if (done_counting) begin
                    next_state = NOTIFY;
                end
            end
            
            NOTIFY: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end
    
    // Output assignments
    assign shift_ena = (current_state == CAPTURE);
    assign counting = (current_state == COUNT);
    assign done = (current_state == NOTIFY);

endmodule