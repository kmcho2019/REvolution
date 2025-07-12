module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

// Define states for the FSM
enum logic [2:0] {
    IDLE,
    SHIFT_DELAY,
    COUNT_DOWN,
    WAIT_ACK
} state, next_state;

// Register to store the delay value
reg [3:0] delay;

// Counter to count down the delay
reg [9:0] counter;

// Register to store the input pattern
reg [3:0] pattern;

// Sequence detector
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        count <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
        counter <= 10'b0000000000;
    end else begin
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    state <= SHIFT_DELAY;
                    pattern <= 4'b0000;
                    delay <= 4'b0000;
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            SHIFT_DELAY: begin
                delay <= {delay[2:0], data};
                if (delay[3] == 1'b1) begin
                    state <= COUNT_DOWN;
                    counter <= {(delay + 1) * 10'd1000};
                    counting <= 1'b1;
                    count <= delay;
                end
            end
            COUNT_DOWN: begin
                if (counter == 10'd0) begin
                    state <= WAIT_ACK;
                    counting <= 1'b0;
                    done <= 1'b1;
                end else begin
                    counter <= counter - 1;
                    if (counter[0] == 1'b0) begin
                        count <= count - 1;
                    end
                end
            end
            WAIT_ACK: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule