module TopModule (
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

// Define the states of the FSM
enum logic [1:0] {IDLE, SHIFT, COUNT, DONE} state, next_state;

// Define the registers to store the pattern, duration, and remaining time
logic [3:0] pattern;
logic [3:0] delay;
logic [11:0] counter;

// Define the register to store the current count
logic [3:0] current_count;

// Define the output signals
assign counting = (state == COUNT);
assign done = (state == DONE);

// Define the sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        delay <= 0;
        counter <= 0;
        current_count <= 0;
    end else begin
        state <= next_state;
        if (state == SHIFT) begin
            pattern <= {pattern[2:0], data};
        end
        if (state == SHIFT && pattern == 4'b1101) begin
            delay <= {delay[2:0], data};
        end
        if (state == COUNT) begin
            if (counter == (delay + 1) * 1000 - 1) begin
                current_count <= current_count - 1;
            end
            counter <= counter + 1;
        end
        if (state == DONE && ack) begin
            state <= IDLE;
        end
    end
end

// Define the combinational logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (data == 1'b1) begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    next_state = SHIFT;
                end
            end else begin
                pattern <= {pattern[2:0], data};
            end
        end
        SHIFT: begin
            if (pattern == 4'b1101) begin
                delay <= {delay[2:0], data};
                if (delay != 0) begin
                    next_state = SHIFT;
                end else begin
                    next_state = COUNT;
                end
            end else begin
                next_state = IDLE;
            end
        end
        COUNT: begin
            if (counter == (delay + 1) * 1000 - 1) begin
                next_state = DONE;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
    count = current_count;
end

endmodule