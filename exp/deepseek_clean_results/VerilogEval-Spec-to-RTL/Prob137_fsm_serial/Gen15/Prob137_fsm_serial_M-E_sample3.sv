module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Only need 2 states
    typedef enum logic {
        IDLE,      // Waiting for start bit
        CAPTURE    // Capturing frame (start + 8 data + stop)
    } state_t;

    reg state, next_state;
    reg [8:0] frame_reg;  // Holds start(LSB) + 8 data + stop(MSB)
    reg done_reg;
    reg start_edge;       // Falling edge detection

    // Falling edge detector for start bit
    reg in_prev;
    always @(posedge clk) begin
        if (reset) begin
            in_prev <= 1'b1;
        end else begin
            in_prev <= in;
        end
    end
    assign start_edge = in_prev && !in;

    // Frame capture shift register
    always @(posedge clk) begin
        if (reset) begin
            frame_reg <= 9'b1_1111_1111; // Initialize to idle state
        end else if (state == CAPTURE) begin
            frame_reg <= {in, frame_reg[8:1]}; // Shift right, MSB first
        end
    end

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 0;
        end else begin
            state <= next_state;
            
            // Done signal when we have valid stop bit and start bit
            if (state == CAPTURE && frame_reg[8] && !frame_reg[0]) begin
                done_reg <= 1'b1;
            end else begin
                done_reg <= 1'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = start_edge ? CAPTURE : IDLE;
            end
            
            CAPTURE: begin
                // Stay in capture until we have valid stop bit
                next_state = (frame_reg[8] && !frame_reg[0]) ? IDLE : CAPTURE;
            end
        endcase
    end

    assign done = done_reg;

endmodule