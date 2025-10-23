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
    end else begin
        case (current_state)
            IDLE_STATE: begin
                // Shift in the new data and check for the pattern '1101'
                pattern_register[3:1] <= pattern_register[2:0];
                pattern_register[0] <= data;
                if (pattern_register == 4'b1101) begin
                    current_state <= SHIFTING_STATE;
                    shift_counter <= 2'b00;
                end else begin
                    current_state <= IDLE_STATE;
                end
            end
            SHIFTING_STATE: begin
                // Assert shift_ena and increment the shift counter
                shift_counter <= shift_counter + 1'b1;
                if (shift_counter == 4) begin
                    current_state <= COUNTING_STATE;
                    shift_counter <= 2'b00;
                end else begin
                    current_state <= SHIFTING_STATE;
                end
            end
            COUNTING_STATE: begin
                // Deassert shift_ena and assert counting
                if (done_counting) begin
                    current_state <= DONE_STATE;
                end else begin
                    current_state <= COUNTING_STATE;
                end
            end
            DONE_STATE: begin
                // Deassert counting and assert done
                if (ack) begin
                    current_state <= IDLE_STATE;
                end else begin
                    current_state <= DONE_STATE;
                end
            end
        endcase
    end
end

// Output logic
assign shift_ena = (current_state == SHIFTING_STATE)? 1'b1 : 1'b0;
assign counting = (current_state == COUNTING_STATE)? 1'b1 : 1'b0;
assign done = (current_state == DONE_STATE)? 1'b1 : 1'b0;

endmodule