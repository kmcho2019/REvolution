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
enum logic [1:0] {
    IDLE = 2'b00,
    SHIFTING = 2'b01,
    COUNTING_STATE = 2'b10,
    DONE_STATE = 2'b11
} current_state, next_state;

// Pattern detection logic
reg [3:0] pattern_register;

// Counter for shifting
reg [1:0] shift_counter;

// Combinational logic for next state
always @(*) begin
    case (current_state)
        IDLE: next_state = (pattern_register == 4'b1101) ? SHIFTING : IDLE;
        SHIFTING: next_state = (shift_counter == 2'b11) ? COUNTING_STATE : SHIFTING;
        COUNTING_STATE: next_state = done_counting ? DONE_STATE : COUNTING_STATE;
        DONE_STATE: next_state = ack ? IDLE : DONE_STATE;
    endcase
end

// Sequential logic for state and output updates
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        pattern_register <= 4'b0000;
        shift_counter <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        pattern_register[3:1] <= pattern_register[2:0];
        pattern_register[0] <= data;
        
        current_state <= next_state;
        
        case (current_state)
            IDLE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFTING: begin
                shift_ena <= 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
                shift_counter <= shift_counter + 1'b1;
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
        
        if (current_state == SHIFTING && shift_counter == 2'b11) begin
            shift_counter <= 2'b00;
        end
    end
end

endmodule