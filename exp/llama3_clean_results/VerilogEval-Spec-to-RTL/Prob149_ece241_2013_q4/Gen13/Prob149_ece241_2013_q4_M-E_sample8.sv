module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define states
enum logic [2:0] {
    STATE_RESET,
    STATE_ABOVE_HIGHEST,
    STATE_BETWEEN_HIGHEST_AND_MIDDLE,
    STATE_BETWEEN_MIDDLE_AND_LOWEST,
    STATE_BELOW_LOWEST
} state, next_state;

// Sequential logic to update state
always @(posedge clk) begin
    if (reset) begin
        state <= STATE_RESET;
    end else begin
        state <= next_state;
    end
end

// Combinational logic to determine next state
always @(*) begin
    case (state)
        STATE_RESET: begin
            if (s == 3'b000) begin
                next_state = STATE_BELOW_LOWEST;
            end else if (s[2] == 1'b0 && s[1] == 1'b0 && s[0] == 1'b1) begin
                next_state = STATE_BETWEEN_MIDDLE_AND_LOWEST;
            end else if (s[2] == 1'b0 && s[1] == 1'b1 && s[0] == 1'b1) begin
                next_state = STATE_BETWEEN_HIGHEST_AND_MIDDLE;
            end else if (s[2] == 1'b1 && s[1] == 1'b1 && s[0] == 1'b1) begin
                next_state = STATE_ABOVE_HIGHEST;
            end else begin
                next_state = state;
            end
        end
        STATE_ABOVE_HIGHEST: begin
            if (s[2] == 1'b0) begin
                next_state = STATE_BETWEEN_HIGHEST_AND_MIDDLE;
            end else begin
                next_state = state;
            end
        end
        STATE_BETWEEN_HIGHEST_AND_MIDDLE: begin
            if (s[1] == 1'b0) begin
                next_state = STATE_BETWEEN_MIDDLE_AND_LOWEST;
            end else if (s[2] == 1'b1) begin
                next_state = STATE_ABOVE_HIGHEST;
            end else begin
                next_state = state;
            end
        end
        STATE_BETWEEN_MIDDLE_AND_LOWEST: begin
            if (s[0] == 1'b0) begin
                next_state = STATE_BELOW_LOWEST;
            end else if (s[1] == 1'b1) begin
                next_state = STATE_BETWEEN_HIGHEST_AND_MIDDLE;
            end else begin
                next_state = state;
            end
        end
        STATE_BELOW_LOWEST: begin
            if (s[0] == 1'b1) begin
                next_state = STATE_BETWEEN_MIDDLE_AND_LOWEST;
            end else begin
                next_state = state;
            end
        end
        default: begin
            next_state = STATE_RESET;
        end
    endcase
end

// Combinational logic to set output signals
always @(*) begin
    case (state)
        STATE_RESET: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
        STATE_ABOVE_HIGHEST: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
        STATE_BETWEEN_HIGHEST_AND_MIDDLE: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = (state == STATE_BETWEEN_HIGHEST_AND_MIDDLE && next_state == STATE_BETWEEN_MIDDLE_AND_LOWEST)? 1'b1 : 1'b0;
        end
        STATE_BETWEEN_MIDDLE_AND_LOWEST: begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (state == STATE_BETWEEN_MIDDLE_AND_LOWEST && next_state == STATE_BELOW_LOWEST)? 1'b1 : 1'b0;
        end
        STATE_BELOW_LOWEST: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
        default: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
    endcase
end

endmodule