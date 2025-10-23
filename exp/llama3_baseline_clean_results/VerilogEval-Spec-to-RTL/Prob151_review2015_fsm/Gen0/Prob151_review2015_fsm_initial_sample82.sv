module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define states
typedef enum logic [1:0] {
    IDLE = 2'b00,
    SHIFT = 2'b01,
    COUNT = 2'b10,
    DONE_WAIT = 2'b11
} state_type;

state_type state, next_state;

// Pattern detection
reg [3:0] pattern;
reg [3:0] shift_counter;

// Reset state
always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_counter <= 4'b0000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        state <= next_state;
        case(state)
            IDLE: begin
                // Shift in data
                pattern <= {data, pattern[3:1]};
                if(pattern == 4'b1101) begin
                    next_state <= SHIFT;
                end
                else begin
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                if(shift_counter == 4'd4) begin
                    next_state <= COUNT;
                    shift_counter <= 4'b0000;
                end
                else begin
                    next_state <= SHIFT;
                    shift_counter <= shift_counter + 1'b1;
                end
            end
            COUNT: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                if(done_counting) begin
                    next_state <= DONE_WAIT;
                end
                else begin
                    next_state <= COUNT;
                end
            end
            DONE_WAIT: begin
                counting <= 1'b0;
                done <= 1'b1;
                if(ack) begin
                    next_state <= IDLE;
                end
                else begin
                    next_state <= DONE_WAIT;
                end
            end
        endcase
    end
end

endmodule