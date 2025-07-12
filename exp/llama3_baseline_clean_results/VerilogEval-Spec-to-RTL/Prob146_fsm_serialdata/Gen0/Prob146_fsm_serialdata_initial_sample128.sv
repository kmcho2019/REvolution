module TopModule(
    input           clk,
    input           in,
    input           reset,
    output [7:0]    out_byte,
    output          done
);

    // Define states for the FSM
    enum logic [2:0] {IDLE, RECEIVING, STOP_CHECK, DONE_STATE} state, next_state;

    // Register for the current state
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Register for the incoming byte
    logic [7:0] byte_reg;
    always_ff @(posedge clk) begin
        if (reset) begin
            byte_reg <= 8'b0;
        end else if (state == RECEIVING) begin
            // Shift in the least significant bit first
            byte_reg <= {byte_reg[6:0], in};
        end else if (state == DONE_STATE) begin
            // No change in this state
        end else begin
            byte_reg <= 8'b0;
        end
    end

    // Output logic
    always_comb begin
        out_byte = byte_reg;
        done = (state == DONE_STATE);
    end

    // Next state logic
    always_comb begin
        case (state)
            IDLE: begin
                if (in == 0) begin
                    // Start bit detected, transition to receiving state
                    next_state = RECEIVING;
                end else begin
                    next_state = IDLE;
                end
            end
            RECEIVING: begin
                if (byte_reg[7] == 1'b1) begin
                    // All 8 bits received, transition to stop bit check
                    next_state = STOP_CHECK;
                end else begin
                    next_state = RECEIVING;
                end
            end
            STOP_CHECK: begin
                if (in == 1) begin
                    // Stop bit received correctly, transition to done state
                    next_state = DONE_STATE;
                end else begin
                    // Incorrect stop bit, wait for a stop bit before resetting
                    next_state = STOP_CHECK;
                end
            end
            DONE_STATE: begin
                // Always transition back to idle state after done
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE_STATE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule