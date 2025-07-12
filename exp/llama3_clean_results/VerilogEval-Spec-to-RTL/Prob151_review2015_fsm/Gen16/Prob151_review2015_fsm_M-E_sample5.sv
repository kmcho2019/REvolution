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
    TIMER_STATE
} current_state;

// Define the sub-states of the timer state
enum logic [1:0] {
    SHIFTING_SUBSTATE,
    COUNTING_SUBSTATE,
    DONE_SUBSTATE
} timer_substate;

// Register to store the input pattern
reg [3:0] pattern_register;

// Counter for shifting
reg [1:0] shift_counter;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE_STATE;
        timer_substate <= SHIFTING_SUBSTATE;
        pattern_register <= 4'b0000;
        shift_counter <= 2'b00;
    end else begin
        case (current_state)
            IDLE_STATE: begin
                // Shift in the new data and check for the pattern '1101'
                pattern_register[3:1] <= pattern_register[2:0];
                pattern_register[0] <= data;
                if (pattern_register == 4'b1101) begin
                    current_state <= TIMER_STATE;
                    timer_substate <= SHIFTING_SUBSTATE;
                    shift_counter <= 2'b00;
                end
            end
            TIMER_STATE: begin
                case (timer_substate)
                    SHIFTING_SUBSTATE: begin
                        // Assert shift_ena and increment the shift counter
                        shift_counter <= shift_counter + 1'b1;
                        if (shift_counter == 4) begin
                            timer_substate <= COUNTING_SUBSTATE;
                            shift_counter <= 2'b00;
                        end
                    end
                    COUNTING_SUBSTATE: begin
                        // Deassert shift_ena and assert counting
                        if (done_counting) begin
                            timer_substate <= DONE_SUBSTATE;
                        end
                    end
                    DONE_SUBSTATE: begin
                        // Deassert counting and assert done
                        if (ack) begin
                            current_state <= IDLE_STATE;
                            timer_substate <= SHIFTING_SUBSTATE;
                        end
                    end
                endcase
            end
        endcase
    end
end

// Output logic
always @(*) begin
    case (current_state)
        IDLE_STATE: begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end
        TIMER_STATE: begin
            case (timer_substate)
                SHIFTING_SUBSTATE: begin
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                COUNTING_SUBSTATE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                end
                DONE_SUBSTATE: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            endcase
        end
    endcase
end

endmodule