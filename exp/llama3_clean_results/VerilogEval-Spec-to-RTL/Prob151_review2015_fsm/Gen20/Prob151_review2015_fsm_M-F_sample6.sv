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

// Define the states of the top-level FSM
enum logic [2:0] {
    IDLE_STATE,
    PATTERN_DETECT_STATE,
    SHIFTING_STATE,
    COUNTING_STATE,
    DONE_STATE
} current_state, next_state;

// Pattern detection mechanism
reg [3:0] pattern_counter;
reg [3:0] pattern_register;

// Shifting mechanism
reg [1:0] shift_counter;

// Sequential logic for state and output updates
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE_STATE;
        pattern_counter <= 4'd0;
        pattern_register <= 4'd0;
        shift_counter <= 2'd0;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (current_state)
            IDLE_STATE: begin
                if (data == 1'b1) begin
                    pattern_register <= {pattern_register[2:0], 1'b1};
                    if (pattern_register == 4'b1101) begin
                        current_state <= PATTERN_DETECT_STATE;
                    end
                end else begin
                    pattern_register <= {pattern_register[2:0], 1'b0};
                end
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            PATTERN_DETECT_STATE: begin
                current_state <= SHIFTING_STATE;
                shift_ena <= 1'b1;
            end
            SHIFTING_STATE: begin
                if (shift_counter == 2'd3) begin
                    shift_ena <= 1'b0;
                    current_state <= COUNTING_STATE;
                end else begin
                    shift_counter <= shift_counter + 1'b1;
                    shift_ena <= 1'b1;
                end
                counting <= 1'b0;
                done <= 1'b0;
            end
            COUNTING_STATE: begin
                counting <= 1'b1;
                if (done_counting) begin
                    current_state <= DONE_STATE;
                end
                shift_ena <= 1'b0;
                done <= 1'b0;
            end
            DONE_STATE: begin
                done <= 1'b1;
                counting <= 1'b0;
                if (ack) begin
                    current_state <= IDLE_STATE;
                    shift_counter <= 2'd0;
                end
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule