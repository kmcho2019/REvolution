module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define the states of the state machine
enum logic [2:0] {
    IDLE_STATE,
    SHIFTING_STATE,
    COUNTING_STATE,
    DONE_STATE
} current_state, next_state;

// Register to store the input pattern
reg [3:0] pattern_register;

// Counter for shifting
reg [1:0] shift_counter;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE_STATE;
        pattern_register <= 4'b0000;
        shift_counter <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (current_state)
            IDLE_STATE: begin
                // Shift in the new data and check for the pattern '1101'
                pattern_register[3:1] <= pattern_register[2:0];
                pattern_register[0] <= data;
                if (pattern_register == 4'b1101) begin
                    next_state <= SHIFTING_STATE;
                end else begin
                    next_state <= IDLE_STATE;
                end
            end
            SHIFTING_STATE: begin
                // Assert shift_ena and increment the shift counter
                shift_ena <= 1'b1;
                shift_counter <= shift_counter + 1'b1;
                if (shift_counter == 4) begin
                    next_state <= COUNTING_STATE;
                    shift_ena <= 1'b0;
                    shift_counter <= 2'b00;
                end else begin
                    next_state <= SHIFTING_STATE;
                end
            end
            COUNTING_STATE: begin
                // Deassert shift_ena and assert counting
                counting <= 1'b1;
                if (done_counting) begin
                    next_state <= DONE_STATE;
                end else begin
                    next_state <= COUNTING_STATE;
                end
            end
            DONE_STATE: begin
                // Deassert counting and assert done
                counting <= 1'b0;
                done <= 1'b1;
                if (ack) begin
                    next_state <= IDLE_STATE;
                    done <= 1'b0;
                end else begin
                    next_state <= DONE_STATE;
                end
            end
        endcase
    end
    current_state <= next_state;
end

endmodule