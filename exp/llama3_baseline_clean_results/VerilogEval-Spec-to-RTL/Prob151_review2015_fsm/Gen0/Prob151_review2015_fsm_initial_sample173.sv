module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNTING, 3: DONE
reg [3:0] shift_counter; // Counter for 4 clock cycles in SHIFT state
reg [3:0] pattern; // Register to store the detected pattern

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to IDLE state
        shift_counter <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (pattern == 4'b1101) begin
                    state <= 1; // Transition to SHIFT state
                    pattern <= 0;
                    shift_counter <= 0;
                end else begin
                    // Update pattern register with the new data bit
                    pattern <= {pattern[2:0], data};
                end
            end
            1: begin // SHIFT state
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4) begin
                    state <= 2; // Transition to COUNTING state
                    shift_counter <= 0;
                end
            end
            2: begin // COUNTING state
                if (done_counting) begin
                    state <= 3; // Transition to DONE state
                end
            end
            3: begin // DONE state
                if (ack) begin
                    state <= 0; // Transition back to IDLE state
                end
            end
            default: begin
                state <= 0; // Default to IDLE state
            end
        endcase
    end
end

always @(*) begin
    shift_ena = (state == 1); // Assert shift_ena in SHIFT state
    counting = (state == 2); // Assert counting in COUNTING state
    done = (state == 3); // Assert done in DONE state
end

endmodule