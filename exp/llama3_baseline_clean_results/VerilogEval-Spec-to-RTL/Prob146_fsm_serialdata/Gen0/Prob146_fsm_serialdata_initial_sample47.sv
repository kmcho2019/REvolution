module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM
enum logic [2:0] {IDLE, START, DATA, STOP, ERROR} state, next_state;

// Counter for data bits
logic [2:0] data_cnt;

// Register for the output byte
logic [7:0] byte_reg;

// Output done signal
logic done_reg;

always_comb begin
    // Default values
    next_state = state;
    done_reg = 1'b0;

    case (state)
        IDLE: begin
            if (~in) begin
                // Start bit detected, move to START state
                next_state = START;
            end
        end

        START: begin
            // Prepare to receive data bits
            next_state = DATA;
        end

        DATA: begin
            if (data_cnt == 8'd7) begin
                // All data bits received, wait for stop bit
                next_state = STOP;
            end
        end

        STOP: begin
            if (in) begin
                // Stop bit received, assert done and move to IDLE state
                done_reg = 1'b1;
                next_state = IDLE;
            end else begin
                // Invalid stop bit, move to ERROR state
                next_state = ERROR;
            end
        end

        ERROR: begin
            if (in) begin
                // Stop bit received, move to IDLE state
                next_state = IDLE;
            end
        end

        default: next_state = IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        // Synchronous reset
        state <= IDLE;
        data_cnt <= 3'd0;
        byte_reg <= 8'd0;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;

        case (state)
            START: begin
                // Reset data counter and output byte
                data_cnt <= 3'd0;
                byte_reg <= 8'd0;
            end

            DATA: begin
                // Shift in the data bit
                byte_reg[7] <= in;
                for (int i = 6; i >= 0; i--) begin
                    byte_reg[i] <= byte_reg[i + 1];
                end

                // Increment data counter
                data_cnt <= data_cnt + 1'd1;
            end

            default: ;
        endcase

        // Update output signals
        out_byte <= byte_reg;
        done <= done_reg;
    end
end

endmodule