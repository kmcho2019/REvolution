module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define the states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE_WAIT
} state, next_state;

// Register to store the current pattern
reg [3:0] pattern;

// Counter for the number of bits shifted in
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        pattern <= 0;
        shift_count <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    next_state <= SHIFT;
                end else if (data) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            SHIFT: begin
                shift_ena <= 1;
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    shift_ena <= 0;
                    next_state <= COUNT;
                end
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    counting <= 0;
                    next_state <= DONE_WAIT;
                end
            end
            DONE_WAIT: begin
                done <= 1;
                if (ack) begin
                    done <= 0;
                    next_state <= IDLE;
                end
            end
        endcase
    end
end

endmodule