module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// States definition
enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6, S7} state, nextState;

// Output signals
logic disc_sig, flag_sig, err_sig;

// Main combinational logic for next state and output calculation
always_comb begin
    // Initialize next state and output signals
    nextState = state;
    disc_sig = 1'b0;
    flag_sig = 1'b0;
    err_sig = 1'b0;

    case(state)
        S0: if (in) begin
                nextState = S1;
            end
        S1: if (in) begin
                nextState = S2;
            end else begin
                nextState = S0;
            end
        S2: if (in) begin
                nextState = S3;
            end else begin
                nextState = S0;
            end
        S3: if (in) begin
                nextState = S4;
            end else begin
                nextState = S0;
            end
        S4: if (in) begin
                nextState = S5;
            end else begin
                nextState = S0;
            end
        S5: if (in) begin
                nextState = S6;
                disc_sig = 1'b1; // Signal to discard bit
            end else begin
                nextState = S0;
            end
        S6: if (in) begin
                nextState = S7;
                err_sig = 1'b1; // Error for 7 or more consecutive 1s
            end else begin
                nextState = S0;
                flag_sig = 1'b1; // Flag for frame boundary
            end
        S7: if (in) begin
                nextState = S7;
                err_sig = 1'b1; // Continue error signal
            end else begin
                nextState = S0;
            end
        default: nextState = S0;
    endcase
end

// Sequential logic for state update and output assignment
always_ff @(posedge clk) begin
    if (reset) begin
        state <= S0;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        disc <= disc_sig;
        flag <= flag_sig;
        err <= err_sig;
    end
end

endmodule