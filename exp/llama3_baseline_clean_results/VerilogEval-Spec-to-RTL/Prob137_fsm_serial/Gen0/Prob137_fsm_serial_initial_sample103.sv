module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

// Define the states of the FSM
enum {IDLE, START, DATA, STOP} state;

// Counter for data bits
reg [2:0] data_bit_counter;

// Variable to store the received data (not required for the output but for completeness)
reg [7:0] received_data;

always_ff @(posedge clk) begin
    if (reset) begin
        // Reset all states and counters
        state <= IDLE;
        data_bit_counter <= 0;
        received_data <= 8'd0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin
                    // Transition to START state upon detecting start bit (0)
                    state <= START;
                end
            end
            START: begin
                // Move to DATA state after receiving the start bit
                state <= DATA;
                data_bit_counter <= 0;
            end
            DATA: begin
                // Collect data bits
                received_data[data_bit_counter] <= in;
                data_bit_counter <= data_bit_counter + 1;
                if (data_bit_counter == 7) begin
                    // Move to STOP state after collecting all data bits
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin
                    // If stop bit is correct (1), output 'done' and transition back to IDLE
                    done <= 1;
                    state <= IDLE;
                end else begin
                    // If stop bit is incorrect, wait for a stop bit (1) before going back to IDLE
                    state <= IDLE;
                end
                // Reset done signal
                done <= 0;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule