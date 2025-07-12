module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [1:0] state, nextState;
reg [1:0] prevState;

// State encoding
parameter S BELOW_S0 = 2'b00;
parameter S_BETWEEN_S1_S0 = 2'b01;
parameter S_BETWEEN_S2_S1 = 2'b10;
parameter S_ABOVE_S2 = 2'b11;

// Output flow rates based on state
always @(state) begin
    case (state)
        S_ABOVE_S2: begin
            fr2 = 0;
            fr1 = 0;
            fr0 = 0;
            dfr = 0;
        end
        S_BETWEEN_S2_S1: begin
            fr2 = 0;
            fr1 = 0;
            fr0 = 1;
            dfr = 0;
        end
        S_BETWEEN_S1_S0: begin
            fr2 = 0;
            fr1 = 1;
            fr0 = 1;
            dfr = 0;
        end
        S_BELOW_S0: begin
            fr2 = 1;
            fr1 = 1;
            fr0 = 1;
            dfr = 0;
        end
    endcase
end

// Next state logic
always @(state, s, prevState) begin
    case (state)
        S_ABOVE_S2: begin
            if (!s[2] && s[1]) begin
                nextState = S_BETWEEN_S2_S1;
            end else if (!s[2] && !s[1] && s[0]) begin
                nextState = S_BETWEEN_S1_S0;
            end else if (!s[2] && !s[1] && !s[0]) begin
                nextState = S_BELOW_S0;
            end else begin
                nextState = S_ABOVE_S2;
            end
        end
        S_BETWEEN_S2_S1: begin
            if (s[2]) begin
                nextState = S_ABOVE_S2;
            end else if (!s[1] && s[0]) begin
                nextState = S_BETWEEN_S1_S0;
            end else if (!s[1] && !s[0]) begin
                nextState = S_BELOW_S0;
            end else begin
                nextState = S_BETWEEN_S2_S1;
            end
        end
        S_BETWEEN_S1_S0: begin
            if (s[2]) begin
                nextState = S_ABOVE_S2;
            end else if (s[1]) begin
                nextState = S_BETWEEN_S2_S1;
            end else if (!s[0]) begin
                nextState = S_BELOW_S0;
            end else begin
                nextState = S_BETWEEN_S1_S0;
            end
        end
        S_BELOW_S0: begin
            if (s[0]) begin
                nextState = S_BETWEEN_S1_S0;
            end else if (s[1]) begin
                nextState = S_BETWEEN_S2_S1;
            end else if (s[2]) begin
                nextState = S_ABOVE_S2;
            end else begin
                nextState = S_BELOW_S0;
            end
        end
    endcase
end

// Update state and set dfr
always @(posedge clk) begin
    if (reset) begin
        state <= S_BELOW_S0;
        prevState <= S_BELOW_S0;
    end else begin
        prevState <= state;
        state <= nextState;
        if ((state == S_BETWEEN_S2_S1 && nextState == S_BETWEEN_S1_S0) ||
            (state == S_BETWEEN_S1_S0 && nextState == S_BELOW_S0)) begin
            dfr <= 1;
        end else if ((state == S_ABOVE_S2 && nextState == S_BETWEEN_S2_S1) ||
                     (state == S_BETWEEN_S2_S1 && nextState == S_BETWEEN_S1_S0) ||
                     (state == S_BETWEEN_S1_S0 && nextState == S_BELOW_S0)) begin
            dfr <= 1;
        end else begin
            dfr <= 0;
        end
    end
end

endmodule