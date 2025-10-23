module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define the states of the FSM
enum logic [1:0] {
    ABOVE,
    BETWEEN_HIGH_MIDDLE,
    BETWEEN_MIDDLE_LOW,
    BELOW
} state, next_state;

// Sequential logic for FSM
always @(posedge clk) begin
    if (reset) begin
        state <= BELOW;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always @(*) begin
    case (state)
        ABOVE: begin
            if (~s[2] && s[1] && s[0]) begin
                next_state = BETWEEN_HIGH_MIDDLE;
            end else if (~s[2] && ~s[1] && s[0]) begin
                next_state = BETWEEN_MIDDLE_LOW;
            end else if (~s[2] && ~s[1] && ~s[0]) begin
                next_state = BELOW;
            end else begin
                next_state = ABOVE;
            end
        end
        BETWEEN_HIGH_MIDDLE: begin
            if (s[2] && s[1] && s[0]) begin
                next_state = ABOVE;
            end else if (~s[2] && ~s[1] && s[0]) begin
                next_state = BETWEEN_MIDDLE_LOW;
            end else if (~s[2] && ~s[1] && ~s[0]) begin
                next_state = BELOW;
            end else begin
                next_state = BETWEEN_HIGH_MIDDLE;
            end
        end
        BETWEEN_MIDDLE_LOW: begin
            if (s[2] && s[1] && s[0]) begin
                next_state = ABOVE;
            end else if (~s[2] && s[1] && s[0]) begin
                next_state = BETWEEN_HIGH_MIDDLE;
            end else if (~s[2] && ~s[1] && ~s[0]) begin
                next_state = BELOW;
            end else begin
                next_state = BETWEEN_MIDDLE_LOW;
            end
        end
        BELOW: begin
            if (s[2] && s[1] && s[0]) begin
                next_state = ABOVE;
            end else if (~s[2] && s[1] && s[0]) begin
                next_state = BETWEEN_HIGH_MIDDLE;
            end else if (~s[2] && ~s[1] && s[0]) begin
                next_state = BETWEEN_MIDDLE_LOW;
            end else begin
                next_state = BELOW;
            end
        end
        default: next_state = BELOW;
    endcase
end

// Combinational logic for output
always @(*) begin
    case (state)
        ABOVE: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
        BETWEEN_HIGH_MIDDLE: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = 1'b0;
        end
        BETWEEN_MIDDLE_LOW: begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b0;
        end
        BELOW: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
        default: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
    endcase
end

endmodule