module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

// Define states
parameter S0 = 7'd0, S1 = 7'd1, S2 = 7'd2, S3 = 7'd3, S4 = 7'd4, S5 = 7'd5, S6 = 7'd6, S7 = 7'd7;

// Current state and next state
reg [6:0] state, next_state;

// Initialize the state machine
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        state <= next_state;
        case (state)
            S5: disc <= 1;
            S6: flag <= 1;
            S7: err <= 1;
            default: begin
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
        endcase
    end
end

// State transitions
always @(*) begin
    case (state)
        S0: begin
            if (in) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (in) next_state = S2;
            else next_state = S0;
        end
        S2: begin
            if (in) next_state = S3;
            else next_state = S0;
        end
        S3: begin
            if (in) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if (in) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if (in) next_state = S6;
            else next_state = S0;
        end
        S6: begin
            if (in) next_state = S7;
            else next_state = S0;
        end
        S7: begin
            if (in) next_state = S7;
            else next_state = S0;
        end
    endcase
end

endmodule