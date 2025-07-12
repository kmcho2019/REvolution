module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// States of the FSM
enum {IDLE, WAITING_FOR_PATTERN, SHIFTING_DELAY, COUNTING, DONE} state;

// Registers to store the input pattern and delay
reg [3:0] pattern;
reg [3:0] delay;
reg [11:0] counter;

// Shift register to detect the input pattern
reg [3:0] shift_register;

always @(posedge clk) begin
    if (reset) begin
        // Reset the state machine to the idle state
        state <= IDLE;
        // Reset the shift register
        shift_register <= 4'b0;
        // Reset the counter
        counter <= 12'd0;
        // Reset the pattern and delay registers
        pattern <= 4'b0;
        delay <= 4'b0;
        // Reset the counting and done outputs
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                // Shift in the incoming data bit
                shift_register <= {data, shift_register[3:1]};
                // Check if the input pattern is detected
                if (shift_register == 4'b1101) begin
                    // Shift the delay bits into the pattern register
                    pattern <= shift_register;
                    state <= WAITING_FOR_PATTERN;
                end
            end
            WAITING_FOR_PATTERN: begin
                // Shift in the next 4 bits to determine the duration of the delay
                shift_register <= {data, shift_register[3:1]};
                // Count the number of bits shifted in
                if (shift_register == 4'b1) begin
                    // Store the delay value
                    delay <= shift_register;
                    state <= SHIFTING_DELAY;
                end
            end
            SHIFTING_DELAY: begin
                // Store the delay value and start counting
                state <= COUNTING;
            end
            COUNTING: begin
                // Decrement the counter
                if (counter == 12'd0) begin
                    // Decrement the delay value
                    delay <= delay - 1;
                    // Reset the counter
                    counter <= 12'd1000;
                end else begin
                    // Decrement the counter
                    counter <= counter - 1;
                end
                // Assert the counting output
                counting <= 1'b1;
                // Output the current remaining time
                count <= delay;
                // Check if the counter has reached 0
                if (delay == 4'd0) begin
                    // Deassert the counting output
                    counting <= 1'b0;
                    // Assert the done output
                    done <= 1'b1;
                    state <= DONE;
                end
            end
            DONE: begin
                // Wait for the ack input to be 1
                if (ack) begin
                    // Deassert the done output
                    done <= 1'b0;
                    // Reset the state machine to the idle state
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule