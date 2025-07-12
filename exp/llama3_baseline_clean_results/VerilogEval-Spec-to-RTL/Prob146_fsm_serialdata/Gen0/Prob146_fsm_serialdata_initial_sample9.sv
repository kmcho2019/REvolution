module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Enum for the states of the FSM
typedef enum logic [2:0] {
    IDLE,
    RECEIVE_DATA,
    STOP,
    DONE
} state_t;

// Current state of the FSM
state_t current_state;

// Next state of the FSM
state_t next_state;

// Register to hold the received byte
reg [7:0] byte_register;

// Counter to keep track of the number of data bits received
reg [2:0] bit_counter;

// Flag to indicate if the stop bit was correctly received
reg stop_bit_received;

always @(posedge clk) begin
    if (reset) begin
        // Reset the FSM to the IDLE state
        current_state <= IDLE;
        byte_register <= 8'd0;
        bit_counter <= 3'd0;
        stop_bit_received <= 1'b0;
    end else begin
        // Update the current state
        current_state <= next_state;

        // Update the byte register and bit counter
        case (current_state)
            IDLE: begin
                byte_register <= 8'd0;
                bit_counter <= 3'd0;
            end
            RECEIVE_DATA: begin
                // Shift the received bit into the byte register
                byte_register <= {byte_register[6:0], in};
                bit_counter <= bit_counter + 1;
            end
            STOP: begin
                // Check if the stop bit was correctly received
                if (in) begin
                    stop_bit_received <= 1'b1;
                end
            end
            DONE: begin
                // Assert the done signal
                done <= 1'b1;
            end
        endcase
    end
end

always @(*) begin
    // Determine the next state of the FSM
    case (current_state)
        IDLE: begin
            if (~in) begin
                // Transition to RECEIVE_DATA if a start bit is received
                next_state = RECEIVE_DATA;
            end else begin
                // Stay in the IDLE state if no start bit is received
                next_state = IDLE;
            end
        end
        RECEIVE_DATA: begin
            if (bit_counter == 8) begin
                // Transition to STOP after receiving all 8 data bits
                next_state = STOP;
            end else begin
                // Stay in RECEIVE_DATA until all 8 data bits are received
                next_state = RECEIVE_DATA;
            end
        end
        STOP: begin
            if (stop_bit_received) begin
                // Transition to DONE if the stop bit was correctly received
                next_state = DONE;
            end else begin
                // Stay in STOP until the stop bit is correctly received
                next_state = STOP;
            end
        end
        DONE: begin
            // Transition back to IDLE after asserting the done signal
            next_state = IDLE;
            done <= 1'b0; // Deassert the done signal
            stop_bit_received <= 1'b0; // Reset the stop bit received flag
        end
    endcase
end

// Assign the output byte
assign out_byte = byte_register;

endmodule