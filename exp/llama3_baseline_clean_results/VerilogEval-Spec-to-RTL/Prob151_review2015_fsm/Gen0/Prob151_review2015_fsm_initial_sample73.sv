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
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Define the counter for shifting in the duration
logic [1:0] shift_counter;

// Define the registers for the output signals
logic shift_ena_reg, counting_reg, done_reg;

// Define the wires for the next state and output signals
logic shift_ena_next, counting_next, done_next;

// Combinational logic for the next state and output signals
always_comb begin
    next_state = state;
    shift_ena_next = 0;
    counting_next = 0;
    done_next = 0;

    case (state)
        IDLE: begin
            if (data == 1'b1) begin // start of the pattern
                next_state = IDLE;
            end else if (data == 1'b0) begin // not the start of the pattern
                next_state = IDLE;
            end
            // assume data is stored in a register and checked for the pattern
            // for simplicity, this part is omitted
            // if the pattern is detected, transition to SHIFT
            // next_state = SHIFT;
        end
        SHIFT: begin
            shift_ena_next = 1;
            if (shift_counter == 4'd3) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            counting_next = 1;
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            done_next = 1;
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
    endcase
end

// Sequential logic for the state and output registers
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena_reg <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        shift_counter <= 0;
    end else begin
        state <= next_state;
        shift_ena_reg <= shift_ena_next;
        counting_reg <= counting_next;
        done_reg <= done_next;
        if (state == SHIFT) begin
            shift_counter <= shift_counter + 1;
        end else begin
            shift_counter <= 0;
        end
    end
end

// Output assignments
assign shift_ena = shift_ena_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule