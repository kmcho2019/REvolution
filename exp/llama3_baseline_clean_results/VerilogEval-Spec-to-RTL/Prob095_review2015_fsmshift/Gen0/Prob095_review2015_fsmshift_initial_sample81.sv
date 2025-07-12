module TopModule(
    input         clk,
    input         reset,
    output        shift_ena
);

reg     [1:0]    state;  // 0: IDLE, 1: SHIFTING, 2-3: transition states
reg     [1:0]    nextState;
reg     [1:0]    counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 1;  // Enter SHIFTING state on reset
        counter <= 0;
    end else begin
        state <= nextState;
        if (state == 1) begin  // If we are in SHIFTING state
            counter <= counter + 1;  // Increment counter
            if (counter == 4) begin  // If we have shifted 4 times
                state <= 0;  // Transition to IDLE state
            end
        end else begin
            counter <= 0;  // Reset counter in IDLE state
        end
    end
end

always @(*) begin
    case (state)
        0: begin  // IDLE state
            shift_ena = 0;
            nextState = 0;
        end
        1: begin  // SHIFTING state
            shift_ena = 1;
            nextState = (counter < 4) ? 1 : 0;
        end
        default: begin
            shift_ena = 0;
            nextState = 0;
        end
    endcase
end

endmodule