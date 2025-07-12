module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    START,
    DATA,
    STOP
} state, next_state;

// Define a counter for the data bits
reg [2:0] data_count;

// Define a register to hold the received data
reg [7:0] data;

always @(*) begin
    // Default next state is the current state
    next_state = state;

    case (state)
        IDLE: begin
            if (~in) begin
                // Start bit detected, transition to START state
                next_state = START;
            end
        end
        START: begin
            // Wait for the 8 data bits
            next_state = DATA;
        end
        DATA: begin
            if (data_count == 7) begin
                // All data bits received, transition to STOP state
                next_state = STOP;
            end else begin
                // Increment the data count and stay in DATA state
                data_count <= data_count + 1;
            end
        end
        STOP: begin
            if (in) begin
                // Stop bit detected, transition back to IDLE state and assert done signal
                next_state = IDLE;
                done = 1'b1;
            end else begin
                // No stop bit detected, stay in STOP state
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        // Reset the FSM to the IDLE state
        state <= IDLE;
        done <= 1'b0;
        data_count <= 3'd0;
        data <= 8'd0;
    end else begin
        // Update the current state
        state <= next_state;

        case (state)
            START: begin
                // Reset the data count and start receiving data bits
                data_count <= 3'd0;
            end
            DATA: begin
                // Shift in the received data bit
                data[7 - data_count] <= in;
            end
            STOP: begin
                // Reset the done signal
                done <= 1'b0;
            end
        endcase
    end
end

endmodule