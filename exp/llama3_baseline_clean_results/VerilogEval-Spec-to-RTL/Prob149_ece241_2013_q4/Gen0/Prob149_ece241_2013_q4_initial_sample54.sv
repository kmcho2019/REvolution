module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define the states of the FSM
enum logic [1:0] {
    BELOW_S0,
    BETWEEN_S0_S1,
    BETWEEN_S1_S2,
    ABOVE_S2
} state, next_state;

// Determine the next state based on the current state and sensor inputs
always_comb begin
    case(state)
        BELOW_S0: begin
            if (s[0]) begin
                next_state = BETWEEN_S0_S1;
            end else begin
                next_state = BELOW_S0;
            end
        end
        BETWEEN_S0_S1: begin
            if (s[1]) begin
                next_state = BETWEEN_S1_S2;
            end else if (!s[0]) begin
                next_state = BELOW_S0;
            end else begin
                next_state = BETWEEN_S0_S1;
            end
        end
        BETWEEN_S1_S2: begin
            if (s[2]) begin
                next_state = ABOVE_S2;
            end else if (!s[1]) begin
                next_state = BETWEEN_S0_S1;
            end else begin
                next_state = BETWEEN_S1_S2;
            end
        end
        ABOVE_S2: begin
            if (!s[2]) begin
                next_state = BETWEEN_S1_S2;
            end else begin
                next_state = ABOVE_S2;
            end
        end
    endcase
end

// Update the current state based on the next state and clock signal
always_ff @(posedge clk) begin
    if (reset) begin
        state <= BELOW_S0;
    end else begin
        state <= next_state;
    end
end

// Determine the output flow rates based on the current state and sensor change
always_comb begin
    case(state)
        BELOW_S0: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
        BETWEEN_S0_S1: begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (state == BETWEEN_S0_S1) && (next_state == BETWEEN_S0_S1 || next_state == BETWEEN_S1_S2);
        end
        BETWEEN_S1_S2: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = (state == BETWEEN_S1_S2) && (next_state == BETWEEN_S1_S2 || next_state == ABOVE_S2);
        end
        ABOVE_S2: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
    endcase
end

endmodule