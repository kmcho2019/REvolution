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

// Combinational logic for next state
always @(*) begin
    case (current_state)
        IDLE_STATE: begin
            if (pattern_register == 4'b1101) begin
                next_state = SHIFTING_STATE;
            end else begin
                next_state = IDLE_STATE;
            end
        end
        SHIFTING_STATE: begin
            if (shift_counter == 4'd3) begin
                next_state = COUNTING_STATE;
            end else begin
                next_state = SHIFTING_STATE;
            end
        end
        COUNTING_STATE: begin
            if (done_counting) begin
                next_state = DONE_STATE;
            end else begin
                next_state = COUNTING_STATE;
            end
        end
        DONE_STATE: begin
            if (ack) begin
                next_state = IDLE_STATE;
            end else begin
                next_state = DONE_STATE;
            end
        end
    endcase
end

// Sequential logic for state and output updates
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE_STATE;
        pattern_register <= 4'b0000;
        shift_counter <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        // Update pattern register
        pattern_register[3:1] <= pattern_register[2:0];
        pattern_register[0] <= data;
        
        // Update state
        current_state <= next_state;
        
        // Update shift counter
        case (current_state)
            SHIFTING_STATE: begin
                shift_counter <= shift_counter + 1'b1;
            end
            default: begin
                shift_counter <= 2'b00;
            end
        endcase
        
        // Update outputs based on current state
        case (current_state)
            IDLE_STATE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFTING_STATE: begin
                shift_ena <= 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
            end
            COUNTING_STATE: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                done <= 1'b0;
            end
            DONE_STATE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
            end
        endcase
    end
end

endmodule