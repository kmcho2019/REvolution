module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

// Define the states of the state machine
enum logic [1:0] {
    ABOVE,
    BETWEEN_2_1,
    BETWEEN_1_0,
    BELOW
} state, next_state;

// Define the flow rates for each state
always_comb begin
    case (state)
        ABOVE: begin
            fr2 = 0;
            fr1 = 0;
            fr0 = 0;
            dfr = 0;
        end
        BETWEEN_2_1: begin
            fr2 = 0;
            fr1 = 0;
            fr0 = 1;
            dfr = (s[1] && !s[2]);
        end
        BETWEEN_1_0: begin
            fr2 = 0;
            fr1 = 1;
            fr0 = 1;
            dfr = (!s[0] && (s[1] || s[2]));
        end
        BELOW: begin
            fr2 = 1;
            fr1 = 1;
            fr0 = 1;
            dfr = 1;
        end
        default: begin
            fr2 = 0;
            fr1 = 0;
            fr0 = 0;
            dfr = 0;
        end
    endcase
end

// Define the next state of the state machine
always_comb begin
    case (state)
        ABOVE: begin
            if (!s[2] && s[1]) next_state = BETWEEN_2_1;
            else if (!s[1] && s[0]) next_state = BETWEEN_1_0;
            else if (!s[0]) next_state = BELOW;
            else next_state = ABOVE;
        end
        BETWEEN_2_1: begin
            if (s[2]) next_state = ABOVE;
            else if (!s[1] && s[0]) next_state = BETWEEN_1_0;
            else if (!s[0]) next_state = BELOW;
            else next_state = BETWEEN_2_1;
        end
        BETWEEN_1_0: begin
            if (s[1] && s[2]) next_state = ABOVE;
            else if (s[1] && !s[2]) next_state = BETWEEN_2_1;
            else if (!s[0]) next_state = BELOW;
            else next_state = BETWEEN_1_0;
        end
        BELOW: begin
            if (s[0]) next_state = BETWEEN_1_0;
            else if (s[1]) next_state = BETWEEN_2_1;
            else if (s[2]) next_state = ABOVE;
            else next_state = BELOW;
        end
        default: next_state = BELOW;
    endcase
end

// Update the state of the state machine
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= BELOW;
    end else begin
        state <= next_state;
    end
end

endmodule