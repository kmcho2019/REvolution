module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

// Define the states of the FSM
enum logic [2:0] {IDLE, SHIFT, COUNT, DONE_WAIT, DONE} state, next_state;

// Register to store the detected pattern
logic [3:0] pattern;

// Counter to count the number of bits shifted in
logic [1:0] shift_count;

// Assign the initial values
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == DONE);

// Sequential logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        pattern <= 4'b0;
        shift_count <= 2'b0;
    end else begin
        state <= next_state;
        if(state == IDLE) begin
            if(pattern == 4'b1101) begin
                pattern <= 4'b0;
                shift_count <= 2'b0;
            end else begin
                pattern <= {pattern[2:0], data};
            end
        end else if(state == SHIFT) begin
            if(shift_count == 2'b11) begin
                shift_count <= 2'b0;
            end else begin
                shift_count <= shift_count + 1'b1;
            end
        end
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    case(state)
        IDLE: begin
            if(pattern == 4'b1101) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            if(shift_count == 2'b11) begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            if(done_counting) begin
                next_state = DONE_WAIT;
            end
        end
        DONE_WAIT: begin
            next_state = DONE;
        end
        DONE: begin
            if(ack) begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule