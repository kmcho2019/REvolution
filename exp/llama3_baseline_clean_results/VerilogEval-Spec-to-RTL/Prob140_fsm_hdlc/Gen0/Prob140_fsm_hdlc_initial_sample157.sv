module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Enumerate the states of the FSM
enum logic [2:0] {
    S0,  // Initial state, previous input was 0
    S1,  // Previous input was 1
    S2,  // Two consecutive 1s
    S3,  // Three consecutive 1s
    S4,  // Four consecutive 1s
    S5,  // Five consecutive 1s
    S6   // Six consecutive 1s
} state, nextState;

// Output signals
logic disc_next, flag_next, err_next;

// Sequential logic
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S0;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        disc <= disc_next;
        flag <= flag_next;
        err <= err_next;
    end
end

// Combinational logic
always_comb begin
    disc_next = 1'b0;
    flag_next = 1'b0;
    err_next = 1'b0;

    case (state)
        S0: begin
            if (in) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
        end
        S1: begin
            if (in) begin
                nextState = S2;
            end else begin
                nextState = S0;
            end
        end
        S2: begin
            if (in) begin
                nextState = S3;
            end else begin
                nextState = S0;
            end
        end
        S3: begin
            if (in) begin
                nextState = S4;
            end else begin
                nextState = S0;
            end
        end
        S4: begin
            if (in) begin
                nextState = S5;
            end else begin
                nextState = S0;
            end
        end
        S5: begin
            if (in) begin
                nextState = S6;
                err_next = 1'b1;
            end else begin
                disc_next = 1'b1;
                nextState = S0;
            end
        end
        S6: begin
            if (in) begin
                err_next = 1'b1;
                nextState = S6;
            end else begin
                flag_next = 1'b1;
                nextState = S0;
            end
        end
        default: begin
            nextState = S0;
        end
    endcase
end

endmodule