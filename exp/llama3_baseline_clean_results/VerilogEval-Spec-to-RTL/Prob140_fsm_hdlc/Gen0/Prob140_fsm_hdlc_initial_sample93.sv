module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Enumerate the states
enum logic [2:0] {
    STATE_0,
    STATE_1,
    STATE_2,
    STATE_3,
    STATE_4,
    STATE_5,
    STATE_6,
    STATE_7
} state, next_state;

// Initialize outputs
assign disc = (state == STATE_5 && in == 0) ? 1'b1 : 1'b0;
assign flag = (state == STATE_6) ? 1'b1 : 1'b0;
assign err = (state == STATE_7) ? 1'b1 : 1'b0;

// State machine logic
always_comb begin
    case (state)
        STATE_0: begin
            if (in) next_state = STATE_1;
            else next_state = STATE_0;
        end
        STATE_1: begin
            if (in) next_state = STATE_2;
            else next_state = STATE_0;
        end
        STATE_2: begin
            if (in) next_state = STATE_3;
            else next_state = STATE_0;
        end
        STATE_3: begin
            if (in) next_state = STATE_4;
            else next_state = STATE_0;
        end
        STATE_4: begin
            if (in) next_state = STATE_5;
            else next_state = STATE_0;
        end
        STATE_5: begin
            if (in) next_state = STATE_6;
            else next_state = STATE_0;
        end
        STATE_6: begin
            if (in) next_state = STATE_7;
            else next_state = STATE_0;
        end
        STATE_7: begin
            if (in) next_state = STATE_7;
            else next_state = STATE_0;
        end
        default: next_state = STATE_0;
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= STATE_0;
    end else begin
        state <= next_state;
    end
end

endmodule