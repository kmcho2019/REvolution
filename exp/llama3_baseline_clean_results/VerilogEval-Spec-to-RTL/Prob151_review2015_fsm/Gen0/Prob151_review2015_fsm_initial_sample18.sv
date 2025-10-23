module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

// Define the states
enum logic [2:0] {IDLE, SHIFT, COUNTING, DONE} state, next_state;

// Counter for shifting bits
logic [1:0] shift_count;

// Pattern detection logic (assuming a simple serial input)
logic [3:0] pattern_detector;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_detector <= 4'b0000;
        shift_count <= 2'b00;
    end else begin
        state <= next_state;
        pattern_detector <= {pattern_detector[2:0], data};
        shift_count <= (state == SHIFT && shift_ena) ? shift_count + 1 : shift_count;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    shift_ena = 0;
    counting = 0;
    done = 0;

    case (state)
        IDLE: begin
            if (pattern_detector == 4'b1101) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            shift_ena = 1;
            if (shift_count == 4'b11) begin
                next_state = COUNTING;
            end
        end
        COUNTING: begin
            counting = 1;
            if (done_counting) begin
                next_state = DONE;
            end
        end
        DONE: begin
            done = 1;
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule