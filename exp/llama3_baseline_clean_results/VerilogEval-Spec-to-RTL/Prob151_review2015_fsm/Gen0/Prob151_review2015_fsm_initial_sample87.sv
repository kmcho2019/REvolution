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

// Define the states of the FSM
enum logic [2:0] {IDLE, SHIFT, COUNTING, DONE} state, next_state;

// Counter for shifting bits
logic [1:0] shift_count;

// Pattern detection
logic [3:0] pattern_reg;

// Initialize outputs
assign shift_ena = (state == SHIFT) ? 1'b1 : 1'b0;
assign counting = (state == COUNTING) ? 1'b1 : 1'b0;
assign done = (state == DONE) ? 1'b1 : 1'b0;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_reg <= 4'b0000;
        shift_count <= 2'b00;
    end else begin
        state <= next_state;
        pattern_reg <= {data, pattern_reg[3:1]};
        if (next_state == SHIFT) begin
            shift_count <= shift_count + 1'b1;
        end else begin
            shift_count <= 2'b00;
        end
    end
end

always_comb begin
    case (state)
        IDLE: begin
            if (pattern_reg == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 4'b100) begin
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule