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
    IDLE,
    SHIFTING,
    COUNTING_STATE,
    DONE_STATE
} current_state, next_state;

// Register to store the input pattern
reg [3:0] pattern_register;

// Counter for shifting
reg [1:0] shift_counter;

always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        pattern_register <= 4'b0000;
        shift_counter <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (current_state)
            IDLE: begin
                pattern_register[3:1] <= pattern_register[2:0];
                pattern_register[0] <= data;
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
                if (pattern_register == 4'b1101) begin
                    next_state <= SHIFTING;
                end else begin
                    next_state <= IDLE;
                end
            end
            SHIFTING: begin
                shift_ena <= 1'b1;
                shift_counter <= shift_counter + 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
                if (shift_counter == 2'b11) begin
                    next_state <= COUNTING_STATE;
                end else begin
                    next_state <= SHIFTING;
                end
            end
            COUNTING_STATE: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                done <= 1'b0;
                if (done_counting) begin
                    next_state <= DONE_STATE;
                end else begin
                    next_state <= COUNTING_STATE;
                end
            end
            DONE_STATE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
                if (ack) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= DONE_STATE;
                end
            end
        endcase
    end
    current_state <= next_state;
end

endmodule